shader_type canvas_item;

// --- Центральные чёрточки ---
uniform int dash_count : hint_range(1, 360) = 12;
uniform float dash_inner : hint_range(0.0, 2.0) = 0.35;
uniform float dash_length : hint_range(0.0, 2.0) = 0.1;
uniform float dash_glow : hint_range(0.0, 0.02) = 0.003;

// --- Многоугольник ---
uniform int vertex_circle_count : hint_range(4, 360) = 12;
uniform int star_step : hint_range(1, 360) = 3;
uniform float star_glow : hint_range(0.0, 0.02) = 0.0015;

// --- Анимация ---
uniform float rotation_speed : hint_range(-5.0, 5.0) = 0.0;
uniform float pulse_speed : hint_range(0.0, 10.0) = 0.0;
uniform float pulse_amount : hint_range(0.0, 0.5) = 0.02;

// --- Внешнее кольцо ---
uniform float outer_circle_radius : hint_range(0.0, 2.0) = 0.85;
uniform float outer_circle_thickness : hint_range(0.0, 0.5) = 0.05;
uniform float outer_circle_glow : hint_range(0.0, 0.02) = 0.003;
// Мелкая внешняя штриховка (36 насечек)
uniform float outer_hatch_glow : hint_range(0.0, 0.02) = 0.0008;
// Кружки-вершины
uniform float vertex_dot_glow : hint_range(0.0, 0.02) = 0.004;
uniform float vertex_ring_glow : hint_range(0.0, 0.02) = 0.008;

// --- Край текстуры (круговая маска) ---
// Ширина кольцевой зоны затухания от центра, в единицах uv (1.0 = половина меньшей стороны текстуры).
// Затухание идёт от радиуса (1 - edge_fade) до радиуса 1.
// 0 — выключено, 0.15 — плавно гаснет в последних 15% радиуса.
uniform float edge_fade : hint_range(0.0, 1.0) = 0.15;

vec2 rot2(vec2 p, float rad) {
	float c = cos(rad);
	float s = sin(rad);
	return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec2 scale2(vec2 p, float r) {
	return p * r;
}

float circle(float pre, vec2 p, float r1, float r2, float power) {
	float leng = length(p);
	float d = min(abs(leng - r1), abs(leng - r2));
	if (r1 < leng && leng < r2) pre /= exp(d) / r2;
	float res = power / d;
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
	float res = power / d;
	return clamp(pre + res, 0.0, 1.0);
}

vec3 calc(vec2 p) {
	float dst = 0.0;
	float T = TIME * rotation_speed;
	// Пульсация: 1.0 + амплитуда * sin(π * speed * TIME)
	float pulse = 1.0 + pulse_amount * sin(PI * pulse_speed * TIME);
	p = scale2(p, pulse);

	// Внешнее кольцо + мелкая внешняя штриховка
	{
		vec2 q = p;
		q = rot2(q, T * PI / 6.0);
		float ht = outer_circle_thickness * 0.5;
		float r_in = outer_circle_radius - ht;
		float r_out = outer_circle_radius + ht;
		dst = circle(dst, q, r_in, r_out, outer_circle_glow);
		dst = radiation(dst, q, r_in + ht * 0.4, r_in + ht * 0.6, 36, outer_hatch_glow);
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
			dst = circle(dst, q - vec2(0.0, outer_circle_radius), 0.001, 0.05, vertex_dot_glow);
			dst = circle(dst, q - vec2(0.0, outer_circle_radius), 0.001, 0.001, vertex_ring_glow);
			q = rot2(q, angle);
		}
	}

	// Центральные радиальные чёрточки
	{
		vec2 q = p;
		q = rot2(q, T * PI / 6.0);
		float r1 = dash_inner;
		float r2 = dash_inner + dash_length;
		dst = radiation(dst, q, r1, r2, dash_count, dash_glow);
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