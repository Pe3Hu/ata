shader_type canvas_item;

uniform float hue : hint_range(0.0, 1.0) = 0.6;
uniform float saturation : hint_range(0.0, 1.0) = 1.0;
uniform float brightness : hint_range(0.0, 2.0) = 1.0;

uniform float alpha_multiplier : hint_range(0.0, 1.0) = 1.0;
// Насколько «белыми» делать ядра кластеров (0 — старое поведение, 1 — полностью белые)
uniform float cluster_whiteness : hint_range(0.0, 1.0) = 1.0;
// Порог/мягкость перехода: чем больше, тем тоньше белые ядра
uniform float cluster_sharpness : hint_range(0.5, 8.0) = 3.0;

const float OCTAVES = 4.0;

vec2 rand2d(vec2 value)
{
    return fract(sin(vec2(
        dot(value, vec2(23.1245, 87.2980)),
        dot(value, vec2(127.5123, 39.183))
    )) * 5387.58135649);
}

float getCell(vec2 uv, float time)
{
    vec2 iuv = floor(uv);
    vec2 fuv = fract(uv);
    float mdist = 1.0;

    for (int y = -1; y <= 1; y++)
    {
        for (int x = -1; x <= 1; x++)
        {
            vec2 n = vec2(float(x), float(y));
            vec2 p = rand2d(iuv + n);

            p.y = 0.5 + 0.5 * sin(time + 5.0 * p.y);
            p.x = 0.5 + 0.5 * cos(time + 5.0 * p.x);

            vec2 diff = n + p - fuv;
            float dist = length(diff);
            mdist = min(mdist, dist);
        }
    }
    return mdist;
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment()
{
    vec4 tex = texture(TEXTURE, UV);

    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 fragCoord = vec2(FRAGCOORD.x, iResolution.y - FRAGCOORD.y);

    vec2 p = fragCoord * 0.01 + 1.0;

    // acc маленькое в центрах кластеров (~0), большое между ними
    float acc = 0.0;
    for (float i = 1.0; i < OCTAVES; i += 1.0)
    {
        acc += getCell(p, TIME) / i;
        p *= OCTAVES;
    }
    acc = pow(acc, 2.2);

    // Маска «внутри кластера»: 1 в ядре, 0 в фоне
    float cluster = 1.0 - clamp(acc, 0.0, 1.0);
    cluster = pow(cluster, cluster_sharpness); // управляем толщиной белых ядер
    cluster = clamp(cluster * cluster_whiteness * 2.0, 0.0, 1.0);

    // Тонированный фон (между кластерами)
    vec3 tint = hsv2rgb(vec3(hue, saturation, brightness));
    vec3 tinted = tint * acc;

    // Ядра кластеров — белые
    vec3 white = vec3(1.0) * (1.0 - acc) * brightness;
    white = clamp(white, 0.0, 1.0);

    vec3 col = mix(tinted, white, cluster);

    float alpha = tex.a * alpha_multiplier;
    COLOR = vec4(col, alpha);
}