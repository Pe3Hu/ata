shader_type canvas_item;

mat2 Rot(float a) {
	float s = sin(a), c = cos(a);
	return mat2(vec2(c, -s), vec2(s, c));
}

float Square(vec2 uv, float size) {
	vec2 s = abs(uv) - vec2(size);
	float square = length(max(s, vec2(0.0)));
	square = smoothstep(0.001, 0.0, square);
	return square;
}

void fragment() {
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = (FRAGCOORD.xy - 0.5 * screen_size) / screen_size.y;
	vec3 col = vec3(1.06);
	float t = sin(4.0 + (sin(TIME) * 0.2 + 0.2));
	uv *= 0.35;
	uv *= Rot(sin(TIME * 0.5));

	for (float i = 0.0; i < 20.5; i += 0.1) {
		uv *= Rot(0.049);
		float size = 0.01 * i;
		col.bg -= i * 0.0001;
		float strength = 0.0037;
		col -= Square(uv, size) * strength;
	}

	col *= col * 2.0;

	float d = length(uv);

	vec2 fs = vec2(0.0, 0.47);
	float focus = smoothstep(fs.x, fs.y, d);
	col += focus;

	col += smoothstep(0.05, 0.0, d) * 0.05;

	col.g += smoothstep(0.06, 0.3, d);
	col.r -= smoothstep(0.06, 0.3, d);
	col = clamp(col, vec3(0.0), vec3(1.0));
	col -= vec3(0.22, 1.0, 1.0);

	col.b = col.r * 0.3;

	COLOR = vec4(col, 1.0);
}