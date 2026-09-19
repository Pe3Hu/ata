shader_type canvas_item;

uniform float pattern_speed : hint_range(0.0, 1.0) = 0.1;  // движение дыма
uniform float palette_speed : hint_range(0.0, 1.0) = 0.05; // перелив цвета

// Только оттенок (H ∈ 0..1). S и V жёстко = 1.0
uniform float hueA : hint_range(0.0, 1.0) = 0.05;
uniform float hueB : hint_range(0.0, 1.0) = 0.75;

// Моменты t, при которых палитра должна попадать в hueA / hueB
uniform float palette_t0 : hint_range(0.0, 1.0) = 0.0;
uniform float palette_t1 : hint_range(0.0, 1.0) = 0.5;

// 0 = как было (тёмное тёмное), 1 = инверсия (тёмное → светлое)
uniform float invert_mask : hint_range(0.0, 1.0) = 1.0;

// Насколько поднять яркость итоговой картинки (0 = без изменений)
uniform float brightness : hint_range(0.0, 1.0) = 0.0;

#define TAU 6.28318530718
#define MAX_ITER 8

// ===============================================================
struct Palette {
    vec3 a;
    vec3 b;
    vec3 c;
    vec3 d;
};

vec3 hsv2rgb(vec3 hsv) {
    vec3 p = abs(fract(hsv.xxx + vec3(0.0, 2.0/3.0, 1.0/3.0)) * 6.0 - 3.0);
    return hsv.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), hsv.y);
}

Palette make_palette_from_two_colors(
    vec3 C0, vec3 C1,
    vec3 c, vec3 d,
    float t0, float t1
) {
    vec3 th0 = TAU * (c * t0 + d);
    vec3 th1 = TAU * (c * t1 + d);
    vec3 cos0 = cos(th0);
    vec3 cos1 = cos(th1);

    vec3 denom = cos0 - cos1;
    const float eps = 1e-5;
    vec3 safe_denom = mix(denom, vec3(1.0), step(abs(denom), vec3(eps)));

    Palette p;
    p.c = c;
    p.d = d;
    p.b = (C0 - C1) / safe_denom;
    p.a = C0 - p.b * cos0;
    return p;
}

vec3 palette_eval(Palette p, float t) {
    return p.a + p.b * cos(TAU * (p.c * t + p.d));
}

void fragment()
{
    vec3 rgbA = hsv2rgb(vec3(hueA, 0.75, 0.75));
    vec3 rgbB = hsv2rgb(vec3(hueB, 0.75, 0.75));

    Palette pal = make_palette_from_two_colors(
        rgbA,
        rgbB,
        vec3(1.0, 1.0, 1.0),   // c
        vec3(0.0, 0.0, 0.0),   // d
        palette_t0,
        palette_t1
    );

    vec4 modulate = COLOR;
    vec4 tex = texture(TEXTURE, UV);
    vec2 uv = SCREEN_UV;

    float pattern_time = TIME * pattern_speed + 23.0;
    float palette_time = TIME * palette_speed;

    vec2 p = mod(uv * TAU, TAU) - 213.0;
    vec2 i = vec2(p);
    float cc = 1.0;
    float inten = 0.005;

    for (int n = 0; n < MAX_ITER; n++) {
        float t = pattern_time * (1.0 - (3.5 / float(n + 1)));
        i = p + vec2(cos(t - i.x) + sin(t + i.y),
                     sin(t - i.y) + cos(t + i.x));
        cc += 1.0 / length(vec2(p.x / (sin(i.x + pattern_time) / inten),
                               p.y / (cos(i.y + pattern_time) / inten)));
    }

    cc /= float(MAX_ITER);
    cc = 1.17 - pow(cc, 1.4);
    vec3 colour = vec3(pow(abs(cc), 10.0));
    colour = clamp(colour + vec3(0.095), 0.0, 1.0);

    // === Главное изменение: инверсия маски ===
    // 0.0 → старое поведение (тёмное остаётся тёмным)
    // 1.0 → тёмное становится светлым
    colour = mix(colour, vec3(1.0) - colour, invert_mask);

    // Общая подсветка итогового цвета
    colour = clamp(colour + vec3(brightness), 0.0, 1.0);

    float palettePhase = abs(sin(uv.x * uv.y + palette_time)) + palette_time;
    vec3 col = palette_eval(pal, palettePhase);
    col *= colour;

    float mask = tex.a;
    vec3 rgb = mix(col, col * tex.rgb, 1.0);
    COLOR = vec4(rgb * modulate.rgb, mask * modulate.a);
}