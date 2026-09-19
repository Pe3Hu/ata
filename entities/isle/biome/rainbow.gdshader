shader_type canvas_item;

// Привязываем к Sprite2D / TextureRect / любой ноде с текстурой.
// SCREEN_UV даёт координаты экрана (0..1) — эффект не зависит от позиции/масштаба узла.
// texture(TEXTURE, UV).a даёт маску по форме твоей текстуры.

uniform float time_scale : hint_range(0.0, 1.0) = 0.01;

#define TAU 6.28318530718
#define MAX_ITER 8

// cosine based palette, 4 vec3 params
// By Inigo Quilez https://iquilezles.org/articles/palettes/
vec3 palette(in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d)
{
    return a + b * cos(6.28318 * (c * t + d));
}

void fragment()
{
    vec4 modulate = COLOR;
    vec4 tex = texture(TEXTURE, UV);
    vec2 uv = SCREEN_UV;

    float time = TIME * time_scale + 23.0;

    vec2 p = mod(uv * TAU, TAU) - 213.0;
    vec2 i = vec2(p);
    float c = 1.0;
    float inten = 0.005;

    for (int n = 0; n < MAX_ITER; n++) {
        float t = time * (1.0 - (3.5 / float(n + 1)));
        i = p + vec2(cos(t - i.x) + sin(t + i.y),
                     sin(t - i.y) + cos(t + i.x));
        c += 1.0 / length(vec2(p.x / (sin(i.x + t) / inten),
                               p.y / (cos(i.y + t) / inten)));
    }

    c /= float(MAX_ITER);
    c = 1.17 - pow(c, 1.4);
    vec3 colour = vec3(pow(abs(c), 10.0));
    colour *= 1.1;
    colour = clamp(colour + vec3(0.095), 0.0, 1.0);

    float palettePhase = abs(sin(uv.x * uv.y + TIME * 0.05)) + TIME * 0.1;
    vec3 col = palette(palettePhase,
                       vec3(0.5, 0.5, 0.5),
                       vec3(0.5, 0.5, 0.5),
                       vec3(1.0, 1.0, 1.0),
                       vec3(0.0, 0.33, 0.67));
    col *= colour;
    float mask = tex.a;
    vec3 rgb = mix(col, col * tex.rgb, 1.0);
    COLOR = vec4(rgb * modulate.rgb, mask * modulate.a);
}