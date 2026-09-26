shader_type canvas_item;

uniform bool  stepify = true;
uniform float value : hint_range(0.0, 1.0) = 1.0;
uniform int   count = 5;              // 5 => сетка 5x5 = 25 ячеек
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

float segmented_grid(vec2 uv) {
	float shape = 0.0;
	float n = float(count);
	float cell = 1.0 / n;
	int total = count * count;

	vec2 inner_size = vec2(1.0 - margin.x, 1.0 - margin.y);

	for (int i = 0; i < 25; i++) {
		if (i >= total) break;

		int col = i / count;                        // 0..count-1 (слева направо)
		int row = count - 1 - (i - col * count);    // снизу вверх!

		float seg_value = float(i + 1) / float(total);

		// Режим "ступенек": пока не набралось — ячейка пустая
		if (stepify && seg_value > value) {
			continue;
		}

		// Локальные координаты внутри ячейки (0..1)
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

	// Наклон всего поля (shear)
	float angle = 1.571 + (shear_angle * PI / 4.0);
	float shear_value = cos(angle) / sin(angle);
	float shear = shear_value * uv.y;
	uv.x = uv.x + shear;
	uv.x -= shear_value / 2.0;

	uv.x *= 1.0 + abs(shear_value);
	uv.x -= abs(shear_value) / 2.0;

	float shape = segmented_grid(uv);

	// Плавный режим — обрезаем по горизонтали
	if (!stepify) {
		shape *= step(uv.x, value);
	}

	shape = clamp(shape, 0.0, 1.0);

	if (invert) {
		shape = 1.0 - shape;
	}

	vec4 col = mix(background_color, bar_color, shape);
	col.a *= bar_color.a;
	COLOR = col;
}