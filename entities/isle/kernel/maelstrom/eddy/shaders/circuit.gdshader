shader_type canvas_item;

#define pi 3.14159
#define tau 6.28318

vec2 random2(vec2 p) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453);
}

const float timeDiv = 5.5;

float voronoi(vec2 uv) {
    vec2 cell = floor(uv);
    vec2 frac = fract(uv);
    float ret = 1.0;
    float change = TIME / timeDiv;

    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
            vec2 neighbor = vec2(float(i), float(j));
            vec2 rand = random2(cell + neighbor);
            rand = 0.5 + 0.5 * sin(change * 4.0 + 2.0 * pi * rand);
            vec2 toCenter = neighbor + rand - frac;
            ret = min(ret, max(abs(toCenter.x), abs(toCenter.y)));
        }
    }
    return ret;
}

vec2 gradient(vec2 x, float thickness) {
    vec2 h = vec2(thickness, 0.0);
    return vec2(voronoi(x + h.xy) - voronoi(x - h.xy),
                voronoi(x + h.yx) - voronoi(x - h.yx)) / (0.9 * h.x);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    uv.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

    uv *= 3.85;

    float val = voronoi(uv) / length(gradient(uv, 0.0235));
    float colVal = pow(val, 3.0) * 3.9;

    vec3 color1 = vec3(0.86 + colVal, 0.86 + colVal, 0.86 + colVal);
    vec3 color2 = vec3(0.6, 0.6, 0.6);
    float mix_factor = 0.5;
    COLOR = vec4(mix(color1, color2, mix_factor), 1.0);
}