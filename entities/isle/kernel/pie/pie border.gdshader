shader_type canvas_item;

uniform vec4 donut_color : source_color = vec4(1.0);
uniform float inner_radius : hint_range(0.0, 0.5) = 0.25;
uniform float outer_radius : hint_range(0.0, 0.5) = 0.45;
uniform float edge_smoothness : hint_range(0.0, 0.05) = 0.005;

void fragment() {
	// Центр ColorRect
	vec2 uv = UV - vec2(0.5);

	// Компенсация aspect ratio, чтобы круг не превращался в эллипс
	float aspect = TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y;
	uv.x *= aspect;

	float dist = length(uv);

	// Внешняя граница
	float outer = smoothstep(
		outer_radius + edge_smoothness,
		outer_radius - edge_smoothness,
		dist
	);

	// Внутренняя граница
	float inner = smoothstep(
		inner_radius - edge_smoothness,
		inner_radius + edge_smoothness,
		dist
	);

	float alpha = outer * inner;

	COLOR = vec4(donut_color.rgb, donut_color.a * alpha);
}