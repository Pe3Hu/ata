shader_type canvas_item;

// Основной цвет, от которого строится палитра
uniform vec3 base_color : source_color = vec3(1.0, 0.4, 0.2);
// Множитель скорости анимации
uniform float time_scale : hint_range(0.0, 4.0) = 1.0;

void fragment() {
    // Разрешение из SCREEN_PIXEL_SIZE (в canvas_item шейдерах VIEWPORT_SIZE нет)
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 fragCoord = FRAGCOORD.xy;

    // Встроенное время Godot
    float t = TIME * time_scale;

    vec2 uv = (fragCoord - 0.5 * iResolution) / max(iResolution.x, iResolution.y);
    vec2 q = 7.0 * uv;

    for (float i = 1.0; i < 40.0; i *= 1.1) {
        vec2 o = q;
        o.x += (0.5 / i) * cos(i * q.y + t * 0.297 + 0.03 * i) + 1.3;
        o.y += (0.5 / i) * cos(i * q.x + t * 0.414 + 0.03 * (i + 10.0)) + 1.9;
        q = o;
    }

    vec3 col = vec3(
        0.5 * sin(3.0 * q.x) + 0.5,
        0.5 * sin(3.0 * q.y) + 0.5,
        sin(1.3 * q.x + 1.7 * q.y)
    );
    float f = 0.43 * (col.x + col.y + col.z);

    vec3 original = vec3(f + 0.6, 0.2 + 0.75 * f, 0.2);

    // Перекраска от base_color
    float lum = clamp(dot(original, vec3(0.299, 0.587, 0.114)), 0.0, 1.0);
    vec3 dark_col   = base_color * 0.15;
    vec3 mid_col    = base_color;
    vec3 bright_col = mix(base_color, vec3(1.0), 0.65);
    vec3 tinted = lum < 0.5
        ? mix(dark_col, mid_col, lum * 2.0)
        : mix(mid_col, bright_col, (lum - 0.5) * 2.0);

    // Маска из встроенной TEXTURE узла
    float mask = texture(TEXTURE, UV).a;
    float alpha = mix(1.0, mask, 1.0);

    COLOR = vec4(tinted, alpha);
}