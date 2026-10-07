shader_type canvas_item;
render_mode unshaded;

uniform sampler2D iChannel0 : repeat_enable, filter_linear_mipmap;
uniform float pixel_size : hint_range(1.0, 32.0) = 8.0;

// ---------- 3D simplex noise ----------
vec3 random3(vec3 c) {
	float j = 4096.0 * sin(dot(c, vec3(17.0, 59.4, 15.0)));
	vec3 r = fract(512.0 * j * vec3(1.0, 0.125, 0.015625)) - 0.5;
	float t = -TIME * 0.5;
	return vec2(r.x * cos(t) + r.y * sin(t),
	            -r.x * sin(t) + r.y * cos(t)).xyy;
}

float noise3(vec3 p) {
	vec3 s = floor(p + dot(p, vec3(1.0 / 3.0)));
	vec3 x = p - s + dot(s, vec3(1.0 / 6.0));
	vec3 e = step(vec3(0.0), x - x.yzx);
	vec3 i1 = e * (1.0 - e.zxy);
	vec3 i2 = 1.0 - e.zxy * (1.0 - e);

	vec3 x1 = x - i1 + 1.0 / 6.0;
	vec3 x2 = x - i2 + 2.0 / 6.0;
	vec3 x3 = x - 1.0 + 3.0 / 6.0;

	vec4 w = max(0.6 - vec4(dot(x, x), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
	vec4 d = vec4(dot(random3(s), x),
	              dot(random3(s + i1), x1),
	              dot(random3(s + i2), x2),
	              dot(random3(s + 1.0), x3));
	w *= w; w *= w;
	return dot(d * w, vec4(52.0));
}

// ---------- 2D simplex noise (iq) ----------
vec2 hash(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	vec2 h = -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
	float t = -TIME * 0.7;
	return vec2(h.x * cos(t) + h.y * sin(t),
	            -h.x * sin(t) + h.y * cos(t));
}

float noise2(vec2 p) {
	const vec2 K = vec2(0.366025404, 0.211324865);
	vec2 i = floor(p + (p.x + p.y) * K.x);
	vec2 a = p - i + (i.x + i.y) * K.y;
	vec2 o = mix(vec2(0.0, 1.0), vec2(1.0, 0.0), step(a.y, a.x));
	vec2 b = a - o + K.y;
	vec2 c = a - 1.0 + 2.0 * K.y;

	float t = TIME * 0.5;
	float co = cos(t), si = sin(t);
	a = vec2(a.x * co + a.y * si, -a.x * si + a.y * co);
	b = vec2(b.x * co + b.y * si, -b.x * si + b.y * co);
	c = vec2(c.x * co + c.y * si, -c.x * si + c.y * co);

	vec3 h = max(0.5 - vec3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
	vec3 n = h * h * h * h * vec3(dot(a, hash(i)),
	                              dot(b, hash(i + o)),
	                              dot(c, hash(i + 1.0)));
	return dot(n, vec3(70.0));
}

// ---------- flow field ----------
float pot(vec2 pos) {
	vec3 p = vec3(pos - vec2(TIME * 0.4, 0.0), TIME * 0.1);
	return noise3(p) + 0.5 * noise3(p * 2.13) + 3.0 * noise2(pos * 0.333);
}

vec2 field(vec2 pos) {
	pos *= 1.5;
	float n = pot(pos);
	float e = 0.1;
	return vec2(-(pot(pos + vec2(0.0, e)) - n),
	             pot(pos + vec2(e, 0.0)) - n) / e;
}

// ---------- main ----------
void fragment() {
	vec2 res = 1.0 / SCREEN_PIXEL_SIZE;

	// --- пикселизация: квантуем координату фрагмента по сетке ---
	vec2 pix = floor(FRAGCOORD.xy / pixel_size) * pixel_size;

	vec2 uv = pix * SCREEN_PIXEL_SIZE;
	uv.x *= res.x / res.y;

	vec3 d = vec3(0.0), e = vec3(0.0);
	float lod = 0.0;

	for (int i = 0; i < 25; i++) {
		d += textureLod(iChannel0, uv - TIME * 0.05, lod).xyz;
		e += textureLod(iChannel0, -uv.yx * 3.0 - TIME * 0.0125, lod).xyz;

		vec2 duv = field(uv) * 0.003125;
		lod += length(duv) * 5.0;
		uv += duv;
	}

	vec3 c = textureLod(iChannel0, uv * 0.1 - TIME * 0.025, lod).xyz;
	d /= 50.0;
	e /= 50.0;
	c = mix(c, d, length(d));
	c = mix(c, e, length(e));

	COLOR = vec4(c, 1.0);
}