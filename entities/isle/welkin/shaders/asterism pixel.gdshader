shader_type canvas_item;

// --- Центральные чёрточки ---
uniform int dash_count : hint_range(0, 16) = 0;
uniform float dash_inner : hint_range(0.0, 2.0) = 0.35;
uniform float dash_length : hint_range(0.0, 2.0) = 0.2;
uniform float dash_glow : hint_range(0.0, 0.02) = 0.005;

// --- Дополнительные перпендикулярные чёрточки (кресты) ---
// Битовая маска: бит i = 1 → радиальная чёрточка для i-го луча включена.
uniform int dash_cross_mask : hint_range(0, 65535) = 0;
uniform float dash_cross_glow : hint_range(0.0, 0.02) = 0.005;

// --- Многоугольник ---
uniform int vertex_circle_count : hint_range(4, 360) = 10;
uniform int star_step : hint_range(1, 360) = 3;
uniform float star_glow : hint_range(0.0, 0.02) = 0.005;

// --- Анимация ---
uniform float rotation_speed : hint_range(-5.0, 5.0) = 0.0;
uniform float pulse_speed : hint_range(0.0, 10.0) = 0.0;
uniform float pulse_amount : hint_range(0.0, 0.5) = 0.02;

// --- Внешнее кольцо ---
uniform float outer_circle_radius : hint_range(0.0, 2.0) = 0.85;
uniform float outer_circle_thickness : hint_range(0.0, 0.5) = 0.05;
uniform float outer_circle_glow : hint_range(0.0, 0.02) = 0.005;
uniform float vertex_dot_glow : hint_range(0.0, 0.02) = 0.004;
uniform float vertex_ring_glow : hint_range(0.0, 0.02) = 0.008;

// --- Засечки на внешнем кольце (свечение) ---
uniform float hatch_glow : hint_range(0.0, 0.02) = 0.002;

// --- Заливка вершин многоугольника ---
// Битовая маска: бит i = 1 → вершина i залита.
uniform int vertex_fill_mask : hint_range(0, 65535) = 0;
uniform float vertex_fill_radius : hint_range(0.0, 0.2) = 0.05;
uniform float vertex_fill_glow : hint_range(0.0, 0.02) = 0.003;

// --- Край текстуры (круговая маска) ---
uniform float edge_fade : hint_range(0.0, 1.0) = 0.15;

vec2 rot2(vec2 p, float rad) {
	float c = cos(rad);
	float s = sin(rad);
	return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec2 scale2(vec2 p, float r) {
	return p * r;
}

// Универсальная проверка бита в маске (до 31 бита).
bool bit_on(int mask, int i) {
	return ((mask >> i) & 1) == 1;
}

float circle(float pre, vec2 p, float r1, float r2, float power) {
	float leng = length(p);
	float d = min(abs(leng - r1), abs(leng - r2));
	if (r1 < leng && leng < r2) pre /= exp(d) / r2;
	float res = power / max(d, 1e-6);
	return clamp(pre + res, 0.0, 1.0);
}

float segment(float pre, vec2 p, vec2 a, vec2 b, float power) {
	vec2 pa = p - a;
	vec2 ba = b - a;
	float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
	float d = length(pa - ba * h);
	return clamp(pre + power / max(d, 1e-6), 0.0, 1.0);
}

float radiation(float pre, vec2 p, float r1, float r2, int num, float power) {
	float angle = 2.0 * PI / float(num);
	float d = 1e10;
	for (int i = 0; i < 360; i++) {
		if (i >= num) break;
		float _d = (r1 < p.y && p.y < r2) ?
			abs(p.x) :
			min(length(p - vec2(0.0, r1)), length(p - vec2(0.0, r2)));
		d = min(d, _d);
		p = rot2(p, angle);
	}
	float res = power / max(d, 1e-6);
	return clamp(pre + res, 0.0, 1.0);
}

// Сплошной закрашенный круг: внутри радиуса — единица, снаружи — свечение.
float disk(float pre, vec2 p, float r, float power) {
	float d = length(p) - r;
	if (d < 0.0) return 1.0;
	return clamp(pre + power / max(d, 1e-6), 0.0, 1.0);
}

vec3 calc(vec2 p) {
	float dst = 0.0;
	float T = TIME * rotation_speed;
	float pulse = 1.0 + pulse_amount * sin(PI * pulse_speed * TIME);
	p = scale2(p, pulse);

	// Внешнее кольцо + мелкая внешняя штриховка (ровно 2 засечки между вершинами)
	{
		vec2 q = p;
		q = rot2(q, T * PI / 6.0);
		float ht = outer_circle_thickness * 0.5;
		float r_in = outer_circle_radius - ht;
		float r_out = outer_circle_radius + ht;
		dst = circle(dst, q, r_in, r_out, outer_circle_glow);

		int n = vertex_circle_count;
		if (n > 0) {
			float step_ang = 2.0 * PI / float(n);
			float base = step_ang * 0.5;      // угол первой вершины
			float third = step_ang / 3.0;     // треть дуги между вершинами

			// Первая засечка — на 1/3 дуги между вершинами
			vec2 q1 = rot2(q, -(base + third));
			dst = radiation(dst, q1, r_in, r_out, n, hatch_glow);

			// Вторая засечка — на 2/3 дуги между вершинами
			vec2 q2 = rot2(q, -(base + 2.0 * third));
			dst = radiation(dst, q2, r_in, r_out, n, hatch_glow);
		}
	}

	// Звёздчатый многоугольник {n/star_step}
	{
		vec2 q = p;
		q = rot2(q, T * PI / 6.0);
		float R = outer_circle_radius;
		float step_ang = 2.0 * PI / float(vertex_circle_count);
		float start = step_ang * 0.5;
		for (int i = 0; i < 360; i++) {
			if (i >= vertex_circle_count) break;
			float a1 = start + float(i) * step_ang;
			float a2 = start + float(i + star_step) * step_ang;
			vec2 va = vec2(R * sin(a1), R * cos(a1));
			vec2 vb = vec2(R * sin(a2), R * cos(a2));
			dst = segment(dst, q, va, vb, star_glow);
		}
	}

	// Внешние круги — вершины многоугольника
	{
		vec2 q = p;
		q = rot2(q, T * PI / 6.0);
		q = rot2(q, 2.0 * PI / float(vertex_circle_count) / 2.0);
		float angle = 2.0 * PI / float(vertex_circle_count);
		for (int i = 0; i < 360; i++) {
			if (i >= vertex_circle_count) break;
			vec2 vp = q - vec2(0.0, outer_circle_radius);
			dst = circle(dst, vp, 0.001, 0.05, vertex_dot_glow);
			dst = circle(dst, vp, 0.001, 0.001, vertex_ring_glow);

			if (i < 16 && bit_on(vertex_fill_mask, i)) {
				dst = disk(dst, vp, vertex_fill_radius, vertex_fill_glow);
			}

			q = rot2(q, angle);
		}
	}

	// Центральные чёрточки: перпендикулярные всегда, радиальные — по биту маски
	{
		vec2 q = p;
		q = rot2(q, T * PI / 6.0);
		float r1 = dash_inner;
		float r2 = dash_inner + dash_length;

		if (dash_count > 0) {
			float step_ang = 2.0 * PI / float(dash_count);
			float rm = (r1 + r2) * 0.5;
			float hl = (r2 - r1) * 0.5;
			vec2 rq = q;
			for (int i = 0; i < 16; i++) {
				if (i >= dash_count) break;

				// Перпендикулярная чёрточка — всегда видна
				{
					vec2 a = vec2(-hl, rm);
					vec2 b = vec2( hl, rm);
					dst = segment(dst, rq, a, b, dash_cross_glow);
				}

				// Радиальная чёрточка — только когда бит i установлен
				if (bit_on(dash_cross_mask, i)) {
					vec2 a = vec2(0.0, r1);
					vec2 b = vec2(0.0, r2);
					dst = segment(dst, rq, a, b, dash_glow);
				}

				rq = rot2(rq, step_ang);
			}
		}
	}

	return pow(dst, 2.5) * vec3(1.0, 0.95, 0.8);
}

void fragment() {
	vec2 res = (TEXTURE_PIXEL_SIZE.x > 0.0) ? 1.0 / TEXTURE_PIXEL_SIZE : 1.0 / SCREEN_PIXEL_SIZE;
	vec2 frag = UV * res;
	vec2 uv = (res - frag * 2.0) / min(res.x, res.y);
	vec3 col = calc(uv);

	float r = length(uv);
	float fade = 1.0 - smoothstep(1.0 - edge_fade, 1.0, r);

	COLOR = vec4(col * fade, 1.0);
}