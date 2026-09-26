shader_type canvas_item;

uniform bool  stepify = true;
uniform float value : hint_range(0.0, 1.0) = 1.0;
uniform int   count = 5;
uniform vec2  margin = vec2(0.25, 0.25);
uniform float shear_angle : hint_range(-1.0, 1.0) = -0.1;

uniform vec4  bar_color        : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4  background_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform bool  invert = false;

// --- Градиент ---
uniform float gradient_strength : hint_range(0.0, 1.0) = 0.35;

// --- «Одеяло»: руки в BL и TR, волна бежит по TL→BR ---
uniform bool  wave_enabled   = true;
uniform float wave_amplitude : hint_range(0.0, 0.5)  = 0.08;
uniform float wave_frequency : hint_range(0.0, 40.0) = 6.0;
uniform float wave_speed     : hint_range(-8.0, 8.0) = 2.0;  // >0: TL→BR, <0: BR→TL

float square_shape(vec2 uv, vec2 size) {
	vec2 bl = step((1.0 - size) / 2.0, uv);
	vec2 tr = step((1.0 - size) / 2.0, 1.0 - uv);
	return bl.x * bl.y * tr.x * tr.y;
}

float segmented_grid(vec2 uv) {
	float shape = 0.0;
	float n = float(count);
	float cell = 1.0 / n;
	int total = count * count;

	vec2 inner_size = vec2(1.0 - margin.x, 1.0 - margin.y);

	for (int i = 0; i < 25; i++) {
		if (i >= total) break;

		int col = i / count;
		int row = count - 1 - (i - col * count);

		float seg_value = float(i + 1) / float(total);

		if (stepify && seg_value > value) {
			continue;
		}

		vec2 cell_uv = vec2(
			(uv.x - float(col) * cell) / cell,
			(uv.y - float(row) * cell) / cell
		);

		shape += square_shape(cell_uv, inner_size);
	}
	return shape;
}

void fragment() {
	vec2 uv = UV;

	// --- Базовый градиент: тёмный левый-низ, светлый правый-верх ---
	float grad = (uv.x - uv.y) * gradient_strength;

	// --- «Одеяло», руки в BL и TR ---
	if (wave_enabled) {
		// Координата ПОПЕРЁК оси рук (BL↔TR): 0 = BL, 1 = TR
		// -> используется как огибающая: нули в углах-руках
		float s = (uv.x - uv.y + 1.0) * 0.5;
		float envelope = 4.0 * s * (1.0 - s);

		// Координата ВДОЛЬ диагонали TL→BR — по ней бежит волна
		float p = (uv.x + uv.y) * 0.5;

		float phase = p * wave_frequency - TIME * wave_speed;

		float raw = sin(phase) * 0.75 + sin(phase * 2.3 + 1.7) * 0.25;

		grad += raw * wave_amplitude * envelope;
	}

	vec3 base_rgb = bar_color.rgb;
	vec3 lighter  = mix(base_rgb, vec3(1.0), clamp( grad, 0.0, 1.0));
	vec3 darker   = mix(base_rgb, vec3(0.0), clamp(-grad, 0.0, 1.0));
	vec3 tinted   = grad >= 0.0 ? lighter : darker;
	vec4 bar_tint = vec4(tinted, bar_color.a);

	// --- Наклон ---
	float angle = 1.571 + (shear_angle * PI / 4.0);
	float shear_value = cos(angle) / sin(angle);
	float shear = shear_value * uv.y;
	uv.x = uv.x + shear;
	uv.x -= shear_value / 2.0;

	uv.x *= 1.0 + abs(shear_value);
	uv.x -= abs(shear_value) / 2.0;

	float shape = segmented_grid(uv);

	if (!stepify) {
		shape *= step(uv.x, value);
	}

	shape = clamp(shape, 0.0, 1.0);

	if (invert) {
		shape = 1.0 - shape;
	}

	vec4 col = mix(background_color, bar_tint, shape);
	col.a *= bar_color.a;
	COLOR = col;
}