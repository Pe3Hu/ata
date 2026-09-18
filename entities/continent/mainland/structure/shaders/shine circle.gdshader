shader_type canvas_item;

const vec3 MOD3 = vec3(0.1031, 0.11369, 0.13787);

// Цвет сияния
uniform vec3 shine_color : source_color = vec3(0.55, 0.75, 1.0);
// Общая яркость
uniform float shine_brightness : hint_range(0.0, 4.0) = 1.0;
// Пикселизация: чем меньше, тем грубее (по высоте текстуры)
uniform float pixel_size : hint_range(16.0, 1024.0) = 32.0;

vec3 hash33(vec3 p3) {
    p3 = fract(p3 * MOD3);
    p3 += dot(p3, p3.yxz + 19.19);
    return -1.0 + 2.0 * fract(vec3(
        (p3.x + p3.y) * p3.z,
        (p3.x + p3.z) * p3.y,
        (p3.y + p3.z) * p3.x
    ));
}

float simplex_noise(vec3 p) {
    const float K1 = 0.333333333;
    const float K2 = 0.166666667;

    vec3 i  = floor(p + (p.x + p.y + p.z) * K1);
    vec3 d0 = p - (i - (i.x + i.y + i.z) * K2);

    vec3 e  = step(vec3(0.0), d0 - d0.yzx);
    vec3 i1 = e * (1.0 - e.zxy);
    vec3 i2 = 1.0 - e.zxy * (1.0 - e);

    vec3 d1 = d0 - (i1 - 1.0 * K2);
    vec3 d2 = d0 - (i2 - 2.0 * K2);
    vec3 d3 = d0 - (1.0 - 3.0 * K2);

    vec4 h = max(0.6 - vec4(dot(d0, d0), dot(d1, d1), dot(d2, d2), dot(d3, d3)), 0.0);
    vec4 n = h * h * h * h * vec4(
        dot(d0, hash33(i)),
        dot(d1, hash33(i + i1)),
        dot(d2, hash33(i + i2)),
        dot(d3, hash33(i + 1.0))
    );

    return dot(vec4(31.316), n);
}

void fragment() {
    // --- лёгкая пикселизация ---
    vec2 tex_size = 1.0 / TEXTURE_PIXEL_SIZE;
    vec2 grid = vec2(tex_size.x / tex_size.y, 1.0) * pixel_size;
    vec2 puv = (floor(UV * grid) + 0.5) / grid;

    // UV как в Shadertoy, но привязанные к размеру текстуры и с флипом Y
    float aspect = TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;
    vec2 uv = vec2((puv.x - 0.5) * aspect, 0.5 - puv.y);

    float a  = sin(atan(uv.y, uv.x));
    float am = abs(a - 0.5) / 4.0;
    float l  = length(uv);

    float m1 = clamp(0.1 / smoothstep(0.0, 1.75, l), 0.0, 1.0);
    float m2 = clamp(0.1 / smoothstep(0.42, 0.0, l), 0.0, 1.0);

    float s1 = (simplex_noise(vec3(uv * 2.0, 1.0 + TIME * 0.525))
                * (max(1.0 - l * 1.75, 0.0)) + 0.9);
    float s2 = (simplex_noise(vec3(uv * 1.0, 15.0 + TIME * 0.525))
                * (max(0.0 + l * 1.0, 0.025)) + 1.25);
    float s3 = (simplex_noise(vec3(vec2(am, am * 100.0 + TIME * 1.0) * 0.15,
                                   30.0 + TIME * 0.525))
                * (max(0.0 + l * 1.0, 0.025)) + 1.25);
    s3 *= smoothstep(0.0, 0.3345, l);

    float sh  = smoothstep(0.15, 0.35, l);
    float sh2 = smoothstep(0.75, 0.30, l);

    float m = m1 * m2 * ((s1 * s2 * s3) * (1.0 - l)) * sh * sh2;
    m = m * m;

    // Масштаб яркости + кламп
    m = clamp(m * shine_brightness, 0.0, 1.0);

    // Цвет: ядро подмешивает белый, края — чистый shine_color
    vec3 col = mix(shine_color, vec3(1.0), smoothstep(0.6, 1.0, m));

    // Чёрный фон → прозрачный
    COLOR = vec4(col * m, m);
}