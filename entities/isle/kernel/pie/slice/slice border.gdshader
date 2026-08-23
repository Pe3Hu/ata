shader_type canvas_item;

uniform vec4 clr : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float thickness = 3.0;
uniform float inner_radius = 280.0;
uniform float outer_radius = 350.0;
uniform float angle_start = 0.0;
uniform float angle_end = 0.19634954;

varying vec2 local_position;

void vertex() {
	local_position = VERTEX;
}

float angle_difference(float a, float b) {
	return atan(sin(a - b), cos(a - b));
}

void fragment() {
	vec2 p = local_position;
	float radius = length(p);
	float angle = atan(p.y, p.x);
	
	float inner_distance = abs(radius - inner_radius);
	float outer_distance = abs(radius - outer_radius);
	
	float start_angle_distance = abs(angle_difference(angle, angle_start));
	float end_angle_distance = abs(angle_difference(angle, angle_end));
	
	float start_distance = start_angle_distance * radius;
	float end_distance = end_angle_distance * radius;
	
	float distance_to_border = min(
		min(inner_distance, outer_distance),
		min(start_distance, end_distance)
	);
	
	float aa = max(fwidth(distance_to_border), 0.0001);
	float border = 1.0 - smoothstep(
	    thickness - aa,
	    thickness + aa,
	    distance_to_border
	);
	
	COLOR = vec4(
		clr.rgb,
		clr.a * border
	);
}