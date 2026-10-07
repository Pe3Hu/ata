shader_type canvas_item;

uniform float CYCLE = 1.0;
uniform float THRESHOLD = 0.4;

// Хеш-функция для шума
float hash12(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

// Сложный шум с тремя кадрами
float complicatedNoise(float t, vec2 uv) {
    float f1 = float(hash12(uv + floor(t) * 10.0) < THRESHOLD);
    float f2 = float(hash12(uv + floor(t + 1.0) * 10.0) < THRESHOLD);
    float f3 = float(hash12(uv + floor(t + 2.0) * 10.0) < THRESHOLD);
    return ((f1 + f2) * 0.5 + f3) * 0.5;
}

// Функция плавного перехода
float ease(float t) {
    return t < 0.5 ? 8.0 * t * t * t * t : 1.0 - 8.0 * (1.0 - t) * t * t * t;
}

// Получение значения цвета в зависимости от времени и скорости
float getColor(vec2 uv, float spd) {
    float tP = TIME / CYCLE * spd + hash12(uv * 10.0);
    float tN = (TIME / CYCLE * spd + 1.0) + hash12(uv * 10.0);
    float prev = complicatedNoise(tP, uv);
    float next = complicatedNoise(tN, uv);
    return mix(prev, next, ease(fract(tP)));
}

void fragment() {
    // Вычисляем разрешение экрана из встроенной переменной Godot
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;

    // Координаты как в Shadertoy: центрируем и нормализуем по высоте
    vec2 uv = (FRAGCOORD.xy - 0.5 * iResolution.xy) / iResolution.y;
    uv *= 12.0;

    // Геометрическая часть — создание сотоподобного узора
    vec2 s = vec2(1.73, 1.0);
    vec2 h = s * 0.5;

    vec2 uv1 = mod(uv, s) - h;
    vec2 uv2 = mod(uv - h, s) - h;
    vec2 uvh = length(uv1) < length(uv2) ? uv1 : uv2;
    vec2 id = uv - uvh;

    // Два слоя шума
    float l1 = getColor(round(id), 0.5);
    float l2 = getColor(round(id * 2.0) + mod(floor(degrees(atan(uvh.x, uvh.y)) / 60.0 + 0.5), 6.0), 1.0);

    // Итоговый цвет (фиолетовый оттенок)
    vec3 col = ((l1 * 0.8 + 0.3) * (l2 * 0.5 + 0.5)) * vec3(0.4, 0.1, 0.8);

    // Берём альфа‑канал из текстуры спрайта, чтобы эффект был виден только там, где есть текстура
    float alpha = texture(TEXTURE, UV).a;
    COLOR = vec4(col, alpha);
}