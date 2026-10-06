shader_type canvas_item;

uniform vec2 iResolution = vec2(1280.0, 720.0);

uniform vec3 line_color : source_color = vec3(0.1, 0.1, 0.5);
uniform vec3 bg_color   : source_color = vec3(1.0, 1.0, 1.0);

uniform float intensity : hint_range(0.0, 1.0) = 0.5;
uniform float thickness : hint_range(0.001, 0.5) = 0.02;

// Насколько широко гасить эффект у краёв (в долях UV, 0..0.5)
uniform float edge_fade : hint_range(0.0, 0.5) = 0.15;

float DistancePointToLine(vec2 p, vec2 A, vec2 B)
{
    float l2 = distance(A, B);
    l2 *= l2;
    if (l2 == 0.0)
        return distance(p, A);

    float t = max(0.0, min(1.0, dot(p - A, B - A) / l2));
    vec2 projection = A + t * (B - A);
    return distance(p, projection);
}

void fragment()
{
    // Маска краёв: 0 у самой границы, 1 внутри
    // UV в Godot: (0,0) — левый верх, (1,1) — правый низ
    vec2 e = smoothstep(vec2(0.0), vec2(edge_fade), UV)
           * smoothstep(vec2(0.0), vec2(edge_fade), 1.0 - UV);
    float edge_mask = e.x * e.y;

    vec2 fragCoord = UV * iResolution;

    vec2 uv = fragCoord / (iResolution * 0.5) - 1.0;
    uv.x *= iResolution.x / iResolution.y;

    float coverage = 0.0;
    float dx = 0.1;

    for (float x = -1.5 - dx; x <= 1.5 + dx; x += dx) {
        vec2 lineA_1 = vec2(x,      cos((x + TIME) * 4.0) / 5.0);
        vec2 lineB_1 = vec2(x + dx, sin((x + TIME + dx) * 3.0) / 5.0);

        float p = DistancePointToLine(uv, lineA_1, lineB_1);
        coverage += thickness / (p + thickness);
    }

    // Гасим покрытие у краёв — прямоугольник исчезает
    float t = clamp(coverage * intensity * edge_mask, 0.0, 1.0);
    vec3 col = mix(bg_color, line_color, t);

    COLOR = vec4(col, 1.0);
}