shader_type canvas_item;

uniform float wave_speed : hint_range(0.0, 5.0) = 1.0;
uniform float wave_frequency : hint_range(0.1, 20.0) = 2.0;
uniform float wave_amplitude : hint_range(0.0, 1.0) = 1.0;
uniform float ring_width : hint_range(0.01, 0.5) = 0.2;
uniform float diamond_width : hint_range(0.1, 2.0) = 0.6;
uniform bool is_critical = false;

uniform vec4 bg_color : source_color = vec4(1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    tex_color = vec4(bg_color.rgb, tex_color.a);

    if (is_critical) {
        vec2 uv_centered = UV - vec2(0.5);
        vec2 uv_scaled = uv_centered;
        uv_scaled.x = uv_centered.x / diamond_width;
        float diamond_dist = abs(uv_scaled.x) + abs(uv_scaled.y);
        
        float max_dist = 0.5;
        float diamond_mask = step(diamond_dist, max_dist);
        float normalized_dist = diamond_dist / max_dist;
        
        float time = TIME * wave_speed;
        float rings = sin(normalized_dist * wave_frequency - time) * wave_amplitude + 0.5;
        
        float ring_pattern = smoothstep(0.5 - ring_width, 0.5 + ring_width, rings);
        vec4 ring_color = tex_color * ring_pattern;
        COLOR = mix(tex_color, ring_color, diamond_mask);
    }
    else {
        COLOR = tex_color;
    }
}