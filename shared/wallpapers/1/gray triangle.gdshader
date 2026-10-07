shader_type canvas_item;

float rand(vec2 co) {
    return fract(sin(mod(dot(co, vec2(12.9898, 78.233)), 3.14)) * 43758.5453);
}

float tnoise(vec2 co) {
    co.y += co.x / 2.0;
    vec2 p = floor(co);
    if (fract(co.x) < fract(co.y)) {
        p += 0.5;
    }
    return rand(p);
}

void fragment() {
    // Разрешение экрана
    vec2 iResolution = vec2(1.0) / SCREEN_PIXEL_SIZE;

    // Экранные координаты (как в исходном Shadertoy)
    vec2 uv_screen = (FRAGCOORD.xy * 2.0 - iResolution) / 40.0;

    float n = tnoise(uv_screen);
    float base = sin(TIME * n * 7.0 + n * 3.141592653589793 * 2.0) * 0.5 + 0.5;
    vec3 col = vec3(base) * 0.3 + 0.5;
    col += sin((uv_screen.x - uv_screen.y) * 30.0) / 2.0;
    col += rand(uv_screen) / 2.0;
    col /= 4.0;

    // Альфа из текстуры (если текстура отсутствует, будет 1)
    float alpha = texture(TEXTURE, UV).a * COLOR.a;

    COLOR = vec4(col, alpha);
}