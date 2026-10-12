shader_type canvas_item;
render_mode unshaded;

// Pixel rect of this veil in viewport space. UV stays top-left, same as Control.
uniform vec2 veil_origin = vec2(0.0);
uniform vec2 veil_size = vec2(1.0);
uniform vec4 dim_color : source_color = vec4(0.0, 0.0, 0.0, 0.72);
uniform int hole_count = 0;
uniform vec4 hole_rects[8];
uniform float hole_radii[8];
uniform float softness = 22.0;

float round_box(vec2 pixel, vec4 rect, float radius) {
	vec2 half_size = rect.zw * 0.5;
	float r = min(radius, min(half_size.x, half_size.y));
	vec2 center = rect.xy + half_size;
	vec2 q = abs(pixel - center) - half_size + vec2(r);
	return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

void fragment() {
	vec2 pixel = veil_origin + UV * veil_size;
	float cover = 1.0;

	float edge = max(softness, 0.001);
	for (int i = 0; i < 8; i++) {
		if (i < hole_count) {
			float dist = round_box(pixel, hole_rects[i], hole_radii[i]);
			cover = min(cover, smoothstep(-edge, edge, dist));
		}
	}

	COLOR = vec4(dim_color.rgb, dim_color.a * cover);
}
