shader_type canvas_item;

#define pi 3.14159

uniform float virtual_side = 320.0;

// Точка перехода градиента по X: 0 = левый край, 1 = правый
uniform float split : hint_range(0.0, 1.0) = 0.5;

float glow(float x, float str, float dist) {
    return dist / pow(x, str);
}

float sinSDF(vec2 st, float A, float offset, float f, float phi) {
    return abs((st.y - offset) + sin(st.x * f + phi) * A);
}

void fragment() {
    vec2 displaySize = 1.0 / vec2(fwidth(UV.x), fwidth(UV.y));
    vec2 fragCoord = UV * displaySize;

    vec2 virtualRes = vec2(virtual_side);
    vec2 coord = fragCoord + (virtualRes - displaySize) * 0.5;
    vec2 st = coord / virtualRes.y;

    float iTime = TIME;

    float col = 0.0;
    float time = iTime / 2.0;
    float str = 0.6;
    float dist = 0.02;
    float nSin = 4.0;

    // Точка разворота волн — как в оригинале, в центре
    float timeHalfInv = -time * sign(st.x - 0.5);
    float am = cos(st.x * 3.0);
    float offset = 0.5 + sin(st.x * 12.0 + time) * am * 0.05;

    for (float i = 0.0; i < nSin; i++) {
        col += glow(
            sinSDF(st, am * 0.2, offset, 6.0, timeHalfInv + i * 2.0 * pi / nSin),
            str,
            dist
        );
    }

    vec3 s = cos(6.0 * st.y * vec3(1.0, 2.0, 3.0) - time * vec3(1.0, -1.0, 1.0)) * 0.5;
    float cut = st.x + (s.x + s.y + s.z) / 33.0;

    // Оригинальная формула, только 0.5 → split
    col = abs(smoothstep(-0.01, -0.03, split - cut) - clamp(col, 0.0, 1.0));

    vec4 tex = texture(TEXTURE, UV);
    COLOR = vec4(vec3(col), 1.0) * tex.a;
}