shader_type canvas_item;

// Цвет вынесен в uniform — можно менять из инспектора/кода.
// Текущий (голубой): vec3(0.01, 0.25, 0.5)
// Оранжевый вариант: vec3(0.75, 0.25, 0.02)
uniform vec3 tint : source_color = vec3(0.01, 0.25, 0.5);

vec3 change_exposure(vec3 col, vec3 b) {
    b *= col;
    return b / (b - col + 1.0);
}

vec3 change_exposure(vec3 col, float b) {
    return change_exposure(col, vec3(b));
}

float planet(vec2 p, vec2 offset, float radius, float res_x) {
    float c = max(0.0, length(p - offset) - radius);
    float circle = exp2(1.0) * exp(-res_x * c);
    float glow   = exp2(1.0) * exp(-61.8 * c);
    return mix(circle, glow, 0.5);
}

void fragment() {
    float t = TIME * 0.5;

    vec2 res = 1.0 / SCREEN_PIXEL_SIZE;

    // ---- ОТРАЖЕНИЕ ПО Y ----
    // Инвертируем вертикальную координату относительно центра экрана
    vec2 fragCoord = vec2(FRAGCOORD.x, res.y - FRAGCOORD.y);

    vec2 uv = (fragCoord - 0.5 * res) / res.x;
    float vignette = length(uv - vec2(0.2 * cos(t), 1.0));
    vignette = 1.2 * 1.5 * exp(-1.2 * vignette * vignette);

    vec2 offset = vec2(0.0, 0.0);
    float circle = planet(uv, offset, 1.0 / 6.0, res.x);

    uv = fragCoord / res - offset;

    vec3 col = change_exposure(
        tint,
        exp2(1.0) * vignette * (1.0 + circle * 16.0 * pow(uv.y, 8.0))
    );

    COLOR = vec4(col, 1.0);
}