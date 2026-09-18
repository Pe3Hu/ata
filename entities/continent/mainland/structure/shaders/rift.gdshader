shader_type canvas_item;

// Размер «блока» пикселизации. 1 = выключено, 2 = легкая, 4+ = сильная.
uniform float pixel_size : hint_range(1.0, 16.0) = 2.;

// Порог прозрачности по «белизне» пикселя.
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.1;

// Мягкость границы прозрачности.
uniform float alpha_softness : hint_range(0.001, 0.5) = 0.05;

// Скорость анимации. 1.0 — базовая скорость, 2.0 — вдвое быстрее, 0.0 — стоп.
uniform float animation_speed : hint_range(0.0, 5.0) = 1.0;

// Стартовый сдвиг фазы (в секундах). Задавай разные значения для разных
// объектов, чтобы они не крутились синхронно.
uniform float time_offset : hint_range(0.0, 100.0) = 0.0;

vec4 permute_3d(vec4 x) {
    return mod(((x * 34.0) + 1.0) * x, 289.0);
}

vec4 taylorInvSqrt3d(vec4 r) {
    return 1.79284291400159 - 0.85373472095314 * r;
}

float simplexNoise3d(vec3 v) {
    const vec2 C = vec2(1.0 / 6.0, 1.0 / 3.0);
    const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);

    vec3 i  = floor(v + dot(v, C.yyy));
    vec3 x0 = v - i + dot(i, C.xxx);

    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min(g.xyz, l.zxy);
    vec3 i2 = max(g.xyz, l.zxy);

    vec3 x1 = x0 - i1 + 1.0 * C.xxx;
    vec3 x2 = x0 - i2 + 2.0 * C.xxx;
    vec3 x3 = x0 - 1.0 + 3.0 * C.xxx;

    i = mod(i, 289.0);
    vec4 p = permute_3d(
        permute_3d(
            permute_3d(i.z + vec4(0.0, i1.z, i2.z, 1.0))
            + i.y + vec4(0.0, i1.y, i2.y, 1.0)
        )
        + i.x + vec4(0.0, i1.x, i2.x, 1.0)
    );

    float n_ = 1.0 / 7.0;
    vec3 ns = n_ * D.wyz - D.xzx;

    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);

    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_);

    vec4 x = x_ * ns.x + ns.yyyy;
    vec4 y = y_ * ns.x + ns.yyyy;
    vec4 h = 1.0 - abs(x) - abs(y);

    vec4 b0 = vec4(x.xy, y.xy);
    vec4 b1 = vec4(x.zw, y.zw);

    vec4 s0 = floor(b0) * 2.0 + 1.0;
    vec4 s1 = floor(b1) * 2.0 + 1.0;
    vec4 sh = -step(h, vec4(0.0));

    vec4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
    vec4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

    vec3 p0 = vec3(a0.xy, h.x);
    vec3 p1 = vec3(a0.zw, h.y);
    vec3 p2 = vec3(a1.xy, h.z);
    vec3 p3 = vec3(a1.zw, h.w);

    vec4 norm = taylorInvSqrt3d(vec4(
        dot(p0, p0),
        dot(p1, p1),
        dot(p2, p2),
        dot(p3, p3)
    ));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;

    vec4 m = max(
        0.6 - vec4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)),
        vec4(0.0)
    );
    m = m * m;

    return 42.0 * dot(
        m * m,
        vec4(dot(p0, x0), dot(p1, x1), dot(p2, x2), dot(p3, x3))
    );
}

float fbm3d(vec3 x, int it) {
    float v = 0.0;
    float a = 0.5;
    vec3 shift = vec3(100.0);

    for (int i = 0; i < 32; ++i) {
        if (i < it) {
            v += a * simplexNoise3d(x);
            x = x * 2.0 + shift;
            a *= 0.5;
        }
    }

    return v;
}

vec3 rotateZ(vec3 v, float angle) {
    float cosAngle = cos(angle);
    float sinAngle = sin(angle);

    return vec3(
        v.x * cosAngle - v.y * sinAngle,
        v.x * sinAngle + v.y * cosAngle,
        v.z
    );
}

float facture(vec3 vector) {
    vec3 normalizedVector = normalize(vector);
    return max(max(normalizedVector.x, normalizedVector.y), normalizedVector.z);
}

vec3 emission(vec3 color, float strength) {
    return color * strength;
}

void fragment() {
    // --- Анимационное время: скорость + стартовый сдвиг ---
    float instance_offset = 0.0;
    float iTime = TIME * animation_speed + time_offset + instance_offset;

    // --- Размер используемой текстуры ---
    vec2 iResolution = 1.0 / TEXTURE_PIXEL_SIZE;

    // --- Легкая пикселизация: квантуем UV до блоков pixel_size ---
    vec2 pixelated_uv = floor(UV * iResolution / pixel_size) * pixel_size / iResolution;

    // Локальные координаты внутри текстуры (0..width, 0..height)
    vec2 fragCoord = pixelated_uv * iResolution;

    // Нормализованные координаты как в Shadertoy (-aspect..aspect по x, -1..1 по y)
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;

    vec3 color = vec3(uv.xy, 0.0);
    color.z += 0.5;

    color = normalize(color);
    color -= 0.2 * vec3(0.0, 0.0, iTime);

    // Защита от log2(0) в центре экрана
    float radius = max(length(uv), 0.0001);
    float angle = -log2(radius);

    color = rotateZ(color, angle);

    float frequency = 1.4;
    float distortion = 0.01;

    color.x = fbm3d(color * frequency + vec3(0.0), 5) + distortion;
    color.y = fbm3d(color * frequency + vec3(1.0), 5) + distortion;
    color.z = fbm3d(color * frequency + vec3(2.0), 5) + distortion;

    vec3 noiseColor = color;

    noiseColor *= 2.0;
    noiseColor -= vec3(0.1);
    noiseColor *= 0.188;
    noiseColor += vec3(uv.xy, 0.0);

    float noiseColorLength = length(noiseColor);
    noiseColorLength = 0.770 - noiseColorLength;
    noiseColorLength *= 4.2;
    noiseColorLength = pow(noiseColorLength, 1.0);

    vec3 emissionColor = emission(vec3(0.961, 0.592, 0.078), noiseColorLength * 0.4);

    float fac = length(uv) - facture(color + vec3(0.32));
    fac += 0.1;
    fac *= 3.0;

    color = mix(emissionColor, vec3(fac), fac + 1.2);

    // --- Обязательно зажимаем цвет в [0..1], иначе альфа будет неверной ---
    vec3 final_color = clamp(color, 0.0, 1.0);

    // --- Белый фон -> прозрачный ---
    float whiteness = min(min(final_color.r, final_color.g), final_color.b);

    float alpha = 1.0 - smoothstep(
        alpha_threshold,
        alpha_threshold + alpha_softness,
        whiteness
    );

    COLOR = vec4(final_color, alpha);
}