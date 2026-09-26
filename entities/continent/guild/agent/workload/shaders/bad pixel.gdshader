shader_type canvas_item;

// --- Прогресс ---
uniform bool  stepify = true;
uniform float value : hint_range(0.0, 1.0) = 1.0;
uniform int   count = 5;

// --- Сетка пикселизации ---
uniform float pixel_size : hint_range(1.0, 32.0) = 4.0;
uniform vec2  rect_size = vec2(256.0, 256.0);

// --- Наклон всего полотна: сдвиг (в блоках) на каждую строку блоков ---
uniform int   shear_step : hint_range(-8, 8) = 1;

// --- Шаблон одной «балки» сектора (в пиксельных блоках) ---
uniform int   beam_w : hint_range(2, 32) = 7;
uniform int   beam_h : hint_range(2, 16) = 7;

// --- Зазор между секторами в пиксельных блоках ---
uniform int   gap : hint_range(0, 8) = 1;

uniform vec4  bar_color        : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4  background_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform bool  invert = false;

// --- Градиент ---
uniform float gradient_strength : hint_range(0.0, 1.0) = 0.35;

// --- «Перетягивание каната» ---
uniform bool  tug_enabled  = true;
uniform float tug_strength : hint_range(0.0, 1.0)  = 0.15;
uniform float tug_speed    : hint_range(0.0, 10.0) = 2.0;

void fragment() {
	vec2 grid = rect_size / pixel_size;

	// --- Габариты всей фигуры (в блоках) ---
	float W = float(beam_w) * float(count);
	float H = float(beam_h) * float(count);
	float s = float(shear_step);
	float S = s * (H - 1.0);
	float bbox_w = W + abs(S);

	vec2 origin = floor((grid - vec2(bbox_w, H)) * 0.5);

	// --- Пиксельный блок ---
	vec2 bc = floor(UV * grid) + 0.5;

	float j = floor(bc.y - origin.y);
	float x_u = -1.0;
	float inside = 1.0;

	if (j < 0.0 || j >= H) {
		inside = 0.0;
	} else {
		float shift_j = s * j;
		x_u = bc.x - origin.x - min(0.0, S) - shift_j;
		if (x_u < 0.0 || x_u >= W) inside = 0.0;
	}

	int   cell_x = 0;
	int   cell_y = 0;
	float seg_value = 1.0;
	float local_x = 0.0;
	float local_y = 0.0;

	if (inside > 0.5) {
		cell_x = int(floor(x_u / float(beam_w)));
		cell_y = int(floor(j   / float(beam_h)));
		if (cell_x < 0 || cell_x >= count || cell_y < 0 || cell_y >= count) {
			inside = 0.0;
		} else {
			// Локальные координаты блока внутри сектора: 0..beam_w, 0..beam_h
			local_x = x_u - float(cell_x) * float(beam_w);
			local_y = j   - float(cell_y) * float(beam_h);

			// --- Зазор: пиксельный, кратен блоку ---
			float g = float(gap);
			if (local_x < g || local_x >= float(beam_w) - g ||
			    local_y < g || local_y >= float(beam_h) - g) {
				inside = 0.0;
			}

			int total = count * count;
			int i = cell_x * count + (count - 1 - cell_y);
			i = clamp(i, 0, total - 1);
			seg_value = float(i + 1) / float(total);
		}
	}

	// Прогресс
	float shape = inside;
	if (stepify) {
		if (seg_value > value) shape = 0.0;
	} else {
		shape *= step(x_u / W, value);
	}

	// --- Градиент и «канат» ---
	vec2 uv_px = vec2(max(x_u, 0.0) / W, max(j, 0.0) / H);
	float grad = (uv_px.x - uv_px.y) * gradient_strength;

	if (tug_enabled) {
		float d        = uv_px.x - uv_px.y;
		float envelope = 1.0 - abs(d);
		grad += sin(TIME * tug_speed) * tug_strength * envelope;
	}

	vec3 base_rgb = bar_color.rgb;
	vec3 lighter  = mix(base_rgb, vec3(1.0), clamp( grad, 0.0, 1.0));
	vec3 darker   = mix(base_rgb, vec3(0.0), clamp(-grad, 0.0, 1.0));
	vec3 tinted   = grad >= 0.0 ? lighter : darker;
	vec4 bar_tint = vec4(tinted, bar_color.a);

	shape = clamp(shape, 0.0, 1.0);
	if (invert) shape = 1.0 - shape;

	vec4 outc = mix(background_color, bar_tint, shape);
	outc.a *= bar_color.a;
	COLOR = outc;
}