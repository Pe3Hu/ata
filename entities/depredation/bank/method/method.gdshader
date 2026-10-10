shader_type canvas_item;

uniform float hue : hint_range(0.0, 1.0) = 0.05;        // оттенок 0..1
uniform float saturation : hint_range(0.0, 1.0) = 1.0;   // насыщенность
uniform float brightness : hint_range(0.0, 1.0) = 1.0;   // яркость

vec3 hsv2rgb(vec3 c) {
    vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

vec2 random2(vec2 st, float seed) {
    st = vec2(
        dot(st, vec2(127.1, 311.7)),
        dot(st, vec2(269.5, 183.3))
    );
    return -1.0 + 2.0 * fract(sin(st) * 43758.5453123 * seed * 0.753421);
}

float map(float value, float fromMin, float fromMax, float toMin, float toMax) {
    value = (value - fromMin) / (fromMax - fromMin);
    value = toMin + value * (toMax - toMin);
    return value;
}

float mapStep(float value, float fromMin, float fromMax, float toMin, float toMax, float steps) {
    value = (value - fromMin) / (fromMax - fromMin);
    value = floor(value * steps) / steps;
    value = toMin + value * (toMax - toMin);
    return value;
}

vec3 linearLight(vec3 a, vec3 b, float factor) {
    return a + factor * (2.0 * b - 1.0);
}

float noise(vec2 st, float seed) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(
        mix(
            dot(random2(i + vec2(0.0, 0.0), seed), f - vec2(0.0, 0.0)),
            dot(random2(i + vec2(1.0, 0.0), seed), f - vec2(1.0, 0.0)),
            u.x
        ),
        mix(
            dot(random2(i + vec2(0.0, 1.0), seed), f - vec2(0.0, 1.0)),
            dot(random2(i + vec2(1.0, 1.0), seed), f - vec2(1.0, 1.0)),
            u.x
        ),
        u.y
    );
}

float fbm(float seed, vec2 st, float scale, int octaves, float roughness, float lacunarity) {
    float amplitude = 0.5;
    float value = 0.0;
    st *= scale;

    for (int i = 1; i < octaves; i++) {
        value += amplitude * noise(st, seed);
        st *= lacunarity;
        amplitude *= roughness;
    }

    return value * 0.5 + 0.5;
}

void fragment() {
    vec2 uv = UV;

    // Сжимаем пламя: левый край (0.0) теперь начинается в 20% от левого края
    float uvX = map(uv.x, 0.4, 1.0, 0.0, 1.0);

    uv = (uv * 2.0 - 1.0);

    vec2 uvFlame = uv + vec2(TIME * 2.0, 0.0);

    float roughness = 0.675;
    int detail = 4;
    float scale = 4.0;
    float lacunarity = 2.0;

    float noise1d = fbm(24.0, uvFlame, scale, detail, roughness, lacunarity);
    vec3 noise3d = vec3(
        fbm(24.0, uvFlame, scale, detail, roughness, lacunarity),
        fbm(12.0, uvFlame, scale, detail, roughness, lacunarity),
        fbm(33.0, uvFlame, scale, detail, roughness, lacunarity)
    );

    float lightFactor = clamp(map(uvX, 0.13, 0.87, 1.0, 0.06), 0.06, 1.0);

    vec3 light = linearLight(vec3(uv * vec2(1.0, 1.0), 0.0), noise3d, lightFactor);
    light = abs(light) - vec3(0.75, 0.0, 0.0);
    light = max(light, vec3(0.0));

    float lightLength = length(light);
    float fireball_grad = clamp(map(uvX, -0.24, 0.82, 0.0, 0.27), 0.0, 0.27);
    lightLength -= fireball_grad;
    lightLength = step(lightLength, -0.01);

    noise1d *= uvX;
    noise1d = mapStep(noise1d, 0.24, 0.77, 0.0, 2.0, 4.0);
    noise1d *= pow(uvX, 4.0);

    vec3 chosen = hsv2rgb(vec3(hue, saturation, brightness));
    vec3 fireColor = mix(chosen, vec3(1.0), clamp(noise1d * 1.5, 0.0, 1.0));

    vec3 color = mix(vec3(1.0), fireColor * noise1d * 4.0, lightLength);

    COLOR = vec4(color, lightLength);
}