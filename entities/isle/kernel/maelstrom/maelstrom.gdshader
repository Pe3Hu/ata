shader_type canvas_item;

//uniform vec4 color: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float hex_radius_frac : hint_range(0.0, 0.4) = 0.4;

bool in_hex(vec2 p, vec2 center, float R) {
    vec2 d = p - center;
    float a = R * 0.8660254;
    return abs(d.x) <= a &&
           abs(0.5 * d.x + 0.8660254 * d.y) <= a &&
           abs(-0.5 * d.x + 0.8660254 * d.y) <= a;
}

void fragment() {
    vec2 pixel_size = TEXTURE_PIXEL_SIZE;
    vec2 p = (UV - vec2(0.5)) / pixel_size;

    float W = 1.0 / pixel_size.x;
    float H = 1.0 / pixel_size.y;
    float circle_R = min(W, H) * 0.5;
    float hex_R = circle_R * hex_radius_frac;
     float d = sqrt(3.0) * hex_R;

    vec2 centers[7];
    centers[0] = vec2(0.0, 0.0);
    for (int i = 1; i <= 6; i++) {
        float angle = float(i - 1) * (3.14159265359 / 3.0);
        centers[i] = vec2(cos(angle), sin(angle)) * d;
    }

    vec4 tex_color = texture(TEXTURE, UV);
    vec4 final_color = tex_color;

    for (int i = 0; i < 7; i++) {
        if (in_hex(p, centers[i], hex_R)) {
            final_color = vec4(0.0, 0.0, 0.0, 0.0);
            break;
        }
    }

    COLOR = final_color;
}