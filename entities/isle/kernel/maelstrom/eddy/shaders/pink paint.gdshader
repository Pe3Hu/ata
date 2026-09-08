shader_type canvas_item;

// --- Качественная хэш-функция (PCG) ---
// Возвращает псевдослучайное значение в диапазоне [0,1)
float hash(vec2 p) {
    uvec2 q = uvec2(ivec2(p));  // приводим к целым
    uint s = q.x * 1664525u + q.y * 1013904223u + 1103515245u;
    s ^= s >> 16u;
    s *= 0x85ebca6bu;
    s ^= s >> 13u;
    s *= 0xc2b2ae35u;
    s ^= s >> 16u;
    return float(s) * (1.0 / 4294967296.0);
}

// Шум с quintic интерполяцией для максимальной гладкости
float noise(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    // Quintic smootherstep: 6t^5 - 15t^4 + 10t^3
    vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);

    float a = hash(p + vec2(0.0, 0.0));
    float b = hash(p + vec2(1.0, 0.0));
    float c = hash(p + vec2(0.0, 1.0));
    float d = hash(p + vec2(1.0, 1.0));

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

const mat2 mtx = mat2(vec2(0.80, 0.60), vec2(-0.60, 0.80));

float fbm(vec2 p) {
    float f = 0.0;
    f += 0.500000 * noise(p); p = mtx * p * 2.02;
    f += 0.250000 * noise(p); p = mtx * p * 2.03;
    f += 0.125000 * noise(p); p = mtx * p * 2.01;
    f += 0.062500 * noise(p); p = mtx * p * 2.04;
    f += 0.031250 * noise(p); p = mtx * p * 2.01;
    f += 0.015625 * noise(p);
    return f / 0.96875;
}

float pattern(vec2 p, float t, out vec2 q, out vec2 r, out vec2 g) {
    q = vec2(fbm(p), fbm(p + vec2(10.0, 1.3)));

    r = vec2(
        fbm(p + 4.0 * q + vec2(t) + vec2(1.7, 9.2)),
        fbm(p + 4.0 * q + vec2(t) + vec2(8.3, 2.8))
    );
    g = vec2(
        fbm(p + 2.0 * r + vec2(t * 20.0) + vec2(2.0, 6.0)),
        fbm(p + 2.0 * r + vec2(t * 10.0) + vec2(5.0, 3.0))
    );
    return fbm(p + 5.5 * g + vec2(-t * 7.0));
}

void fragment() {
    // Маска по текстуре объекта
    vec4 tex_color = texture(TEXTURE, UV);
    float mask = tex_color.a;

    // Координаты, привязанные к экрану
    vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 p = SCREEN_UV * screen_size * 0.004;
    float t = TIME * 0.007;

    vec2 q, r, g;
    float noise_val = pattern(p, t, q, r, g);

    // Цветовая схема (как в оригинале)
    vec3 col = mix(vec3(0.1, 0.4, 0.4), vec3(0.5, 0.7, 0.0),
                   smoothstep(0.0, 1.0, noise_val));
    col = mix(col, vec3(0.35, 0.0, 0.1), dot(q, q) * 1.0);
    col = mix(col, vec3(0.0, 0.2, 1.0), 0.2 * g.y * g.y);
    col = mix(col, vec3(0.3, 0.0, 0.0), smoothstep(0.0, 0.6, 0.6 * r.g * r.g));
    col = mix(col, vec3(0.0, 0.5, 0.0), 0.1 * g.x);
    col = mix(col, vec3(0.0),
              smoothstep(0.3, 0.5, noise_val) * smoothstep(0.5, 0.3, noise_val));
    col = mix(col, vec3(0.0),
              smoothstep(0.7, 0.8, noise_val) * smoothstep(0.8, 0.7, noise_val));
    col *= noise_val * 2.0;

    // Виньетка по экрану
    col *= 0.70 + 0.65 * sqrt(70.0 * SCREEN_UV.x * SCREEN_UV.y *
                             (1.0 - SCREEN_UV.x) * (1.0 - SCREEN_UV.y));

    // Применяем маску
    COLOR = vec4(col, 1.0) * mask;
}