shader_type canvas_item;

// Хеш-функция
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// Шумовая функция
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
               u.y);
}

void fragment() {
    // Используем экранные UV (привязка ко всему экрану)
    vec2 screen_uv = SCREEN_UV;
    vec2 uv = (screen_uv - 0.5) * 2.0;
    uv.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x; // коррекция аспекта

    vec3 color = vec3(1.0);
    int bg_iter = int(TIME) + 12;
    // Начинаем с безопасного индекса, чтобы не считать отрицательные радиусы
    int start_i = max(0, int(TIME) - 5);

    // Проходим по кольцам
    for (int i = start_i; i < bg_iter; i++) {
        float radius_noise = noise(uv * 70.0 + float(i) + sin(TIME)) * 0.1;
        float radius = float(i) / 5.2 - TIME / 5.2 + radius_noise;

        if (length(uv) < radius) {
            if (i == bg_iter - 1) {
                color -= vec3(fract(TIME) * 0.1);
            } else {
                color -= vec3(0.1);
            }
        }
    }

    // Получаем альфу текстуры (маска видимости)
    float tex_alpha = texture(TEXTURE, UV).a;

    // Итоговый цвет: эффект с альфой текстуры
    COLOR = vec4(color, tex_alpha);
}