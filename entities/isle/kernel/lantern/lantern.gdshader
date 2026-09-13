shader_type canvas_item;

// Assign your textures to these in the inspector
uniform sampler2D iChannel0 : hint_default_black, filter_linear, repeat_enable;
uniform sampler2D iChannel1 : hint_default_black, filter_linear, repeat_enable;

// Drive iTime from GDScript: material.set_shader_parameter("iTime", t)
uniform float iTime = 0.0;

// Set from GDScript to the viewport size (or leave default and use screen size)
uniform vec2 iResolution = vec2(1920.0, 1080.0);


void fragment() {
    // FRAGCOORD.xy is equivalent to Shadertoy's fragCoord
    vec2 fragCoord = FRAGCOORD.xy;
    vec2 uv = fragCoord / iResolution;

    float o = texture(iChannel1, uv * 0.25 + vec2(0.0, iTime * 0.025)).r;
    float d = texture(iChannel0, uv * 0.25 - vec2(0.0, iTime * 0.02 + o * 0.02)).r * 2.0 - 1.0;

    float v = uv.y + d * 0.1;
    v = 1.0 - abs(v * 2.0 - 1.0);
    v = pow(v, 2.0 + sin((iTime * 0.2 + d * 0.25) * TAU) * 0.5);

    vec3 color = vec3(0.0);

    float x = (1.0 - uv.x * 0.75);
    float y = 1.0 - abs(uv.y * 2.0 - 1.0);
    color += vec3(x * 0.5, y, x) * v;

    vec2 seed = fragCoord.xy;
    vec2 r;
    r.x = fract(sin((seed.x * 12.9898) + (seed.y * 78.2330)) * 43758.5453);
    r.y = fract(sin((seed.x * 53.7842) + (seed.y * 47.5134)) * 43758.5453);

    float s = mix(r.x,
                  (sin((iTime * 2.5 + 60.0) * r.y) * 0.5 + 0.5) * ((r.y * r.y) * (r.y * r.y)),
                  0.04);
    color += pow(s, 70.0) * (1.0 - v);

    COLOR.rgb = color;
    COLOR.a = 1.0;
}