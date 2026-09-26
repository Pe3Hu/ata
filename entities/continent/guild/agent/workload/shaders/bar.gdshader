shader_type canvas_item;

uniform bool  stepify = true;
uniform float value : hint_range(0.0, 1.0) = 1.0;
uniform int   count = 25;
uniform vec2  margin = vec2(0.25, 0.25);
uniform float shear_angle : hint_range(-1.0, 1.0) = -0.1;

uniform vec4  bar_color        : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4  background_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform bool  invert = false;

float square_shape(vec2 uv, vec2 size) {
	vec2 bl = step((1.0 - size) / 2.0, uv);
	vec2 tr = step((1.0 - size) / 2.0, 1.0 - uv);
	return bl.x * bl.y * tr.x * tr.y;
}

float segmented_bar(vec2 uv) {
	float shape = 0.0;
	float bar_count = float(count);
	float bar_size = 1.0 / bar_count;
	float separation_width = margin.x * bar_size;

	for (int i = 0; i < count; i++) {
		float index_value = float(i + 1) / float(count);

		if (index_value > value) {
			if (value < float(i) * bar_size || value <= 0.0) {
				continue;
			}
		}

		vec2 uv4 = uv;
		vec2 size4 = vec2(bar_size, 1.0 - margin.y);
		uv4.x = uv4.x - (bar_size / 2.0) + 0.5;
		uv4.x -= bar_size * float(i);
		size4.x -= separation_width;

		shape += square_shape(uv4, size4);
	}
	return shape;
}

void fragment() {
	vec2 uv = UV;

	// Наклон (shear)
	float angle = 1.571 + (shear_angle * PI / 4.0);
	float shear_value = cos(angle) / sin(angle);
	float shear = shear_value * uv.y;
	uv.x = uv.x + shear;
	uv.x -= shear_value / 2.0;

	uv.x *= 1.0 + abs(shear_value);
	uv.x -= abs(shear_value) / 2.0;

	float shape = segmented_bar(uv);

	// Если stepify выключен — плавная заливка по значению
	if (!stepify) {
		shape *= step(uv.x, value);
	}

	shape = clamp(shape, 0.0, 1.0);

	if (invert) {
		shape = 1.0 - shape;
	}

	// Рисуем цветом: фон + цвет сегментов
	vec4 col = mix(background_color, bar_color, shape);
	col.a *= bar_color.a; // альфа сегментов
	COLOR = col;
}