shader_type canvas_item;

// =============================================================================
// FIRE CONTROLS
// =============================================================================
uniform float speed : hint_range(0.1, 5.0) = 1.0;
uniform float pixelSize : hint_range(1.0, 16.0) = 8.0;
uniform float alpha : hint_range(0.0, 1.0) = 0.95;
uniform float flickerStrength : hint_range(0.0, 0.5) = 0.15;

// =============================================================================
// COLORS
// =============================================================================
uniform vec3 toColor   : source_color = vec3(0.4, 0.35, 0.2);
uniform vec3 fromColor : source_color = vec3(0.9, 0.2, 0.1);

// =============================================================================
// FIRE SIMULATION
// =============================================================================
uniform float particleCount : hint_range(16.0, 512.0) = 128.0;
uniform float brightness : hint_range(0.0001, 0.01) = 0.001;
uniform float fireShift : hint_range(0.0, 0.5) = 0.15;
uniform float fireShiftFrequency : hint_range(1.0, 10.0) = 5.0;

uniform vec2 size  = vec2(0.05, 2.0);
uniform vec2 glow  = vec2(0.001, 0.04);

uniform float aspectRatio : hint_range(0.01, 5.0) = 1.0;
uniform vec2 posOffset = vec2(0.0, -0.75);

// Угол гравитации в градусах.
//   0   = гравитация вниз, пламя вверх (по умолчанию)
//  ±90  = пламя наклоняется в сторону
// Поворот идёт как жёсткий вокруг ЦЕНТРА текстуры — источник и
// факел разворачиваются вместе, ничего не улетает за край.
uniform float gravityAngle : hint_range(-180.0, 180.0) = 0.0;

// =============================================================================
// HELPERS
// =============================================================================
float Hash1(float t) {
    return fract(cos(t * 124.97) * 248.842) - 0.5;
}

float saturate(float x) {
    return clamp(x, 0.0, 1.0);
}

// =============================================================================
// FIRE SIMULATION
// =============================================================================
vec3 Simulate(vec2 uv, float t) {
    vec3 res = vec3(0.0);

    for (float i = 0.0; i < particleCount; i++) {
        float ct = fract(t + (i + 1.0) / particleCount);
        float seed = Hash1((i + 1.0) * (t - ct));

        vec2 dir = vec2(0.0, size.y);

        dir.x += (cos(t * seed) * sin(ct * fireShiftFrequency))
                 * mix(0.0, fireShift, log(ct));

        float cb = saturate(mix(brightness, 0.0, ct));
        vec2 off = vec2(seed * size.x, 0.0);

        res += mix(fromColor * abs(seed), toColor, ct)
             * smoothstep(glow.x, glow.y,
                          cb / length(uv - off - (dir * ct)));
    }
    return res;
}

// =============================================================================
// FRAGMENT
// =============================================================================
void fragment() {
    // Пикселизация: блок pixelSize × pixelSize экранных пикселей
    vec2 block = SCREEN_PIXEL_SIZE * pixelSize;
    vec2 pix_uv = floor(UV / block) * block;

    // Координаты от центра текстуры, +Y вверх
    vec2 frag_coords = pix_uv * 2.0 - 1.0;
    frag_coords.x *= aspectRatio;
    frag_coords.y *= -1.0;

    // --- Гравитация: жёсткий поворот вокруг ЦЕНТРА текстуры ---
    // Центр текстуры в этих координатах — это (0, 0).
    float ga = radians(gravityAngle);
    float cg = cos(ga);
    float sg = sin(ga);
    frag_coords = vec2(frag_coords.x * cg - frag_coords.y * sg,
                       frag_coords.x * sg + frag_coords.y * cg);

    // Теперь переносим начало координат в точку испускания.
    // Источник и направление пламени повёрнуты вместе, но всё
    // остаётся внутри текстуры.
    frag_coords -= posOffset;

    float base_time = TIME + 100.0;
    vec3 fire_color = Simulate(frag_coords, base_time * speed);

    // Мерцание
    float flicker = (Hash1(base_time * 5.0) + 0.5) * flickerStrength;
    vec3 final_color = fire_color * (1.0 + flicker);

    // Альфа по интенсивности
    float intensity = max(max(fire_color.r, fire_color.g), fire_color.b);
    float final_alpha = smoothstep(0.01, 0.5, intensity) * alpha;

    COLOR = vec4(final_color * alpha, final_alpha);
}