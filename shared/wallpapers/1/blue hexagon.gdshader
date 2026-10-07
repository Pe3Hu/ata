shader_type canvas_item;

uniform float FACTOR = 20.0;

float HexDist(vec2 p, vec2 id) {
    float t = TIME;
    float ca = cos(t - id.x / FACTOR);
    float sa = sin(t);
    // Матрица через два столбца — работает во всех версиях
    mat2 rot = mat2(vec2(ca, sa), vec2(-sa, ca));
    p *= rot * 1.3;
    p = abs(p);
    float c = dot(p, normalize(vec2(1.0, 1.73)));
    return max(c, p.x);
}

vec4 HexCoords(vec2 uv) {
    vec2 rep = vec2(1.0, 1.73);
    vec2 h = rep * 0.5;
    vec2 a = mod(uv, rep) - h;
    vec2 b = mod(uv - h, rep) - h;

    vec2 gv;
    if (length(a) < length(b))
        gv = a;
    else
        gv = b;

    vec2 id = (uv - gv) + FACTOR;
    float y = 0.5 - HexDist(gv, id);
    return vec4(gv.x, y, id.x, id.y);
}

void fragment() {
    vec2 view_size = 1.0 / SCREEN_PIXEL_SIZE; // разрешение экрана в пикселях
    vec2 uv = (FRAGCOORD.xy - 0.5 * view_size) / view_size.y; // центрируем и нормализуем

    vec3 col = vec3(0.0);

    uv *= FACTOR;
    vec4 hexC = HexCoords(uv);
    float t = mod(TIME, 2000.0);

    col += smoothstep(0.05, 0.1, hexC.y * sin(hexC.w * hexC.z + t));
    col += smoothstep(0.2, 0.15, hexC.y);
    col += 0.5 - smoothstep(0.15, 0.1, hexC.y);
    col *= (0.7 + sin((hexC.z / 3.0) + TIME) * 0.3) * vec3(0.4, 0.7, 1.0);
    col += vec3(0.3, 0.4, 0.8) * 0.2;

    COLOR = vec4(col, 1.0);
}