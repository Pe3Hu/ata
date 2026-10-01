shader_type canvas_item;

uniform float speed = 1.0;

void fragment() {
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 I = FRAGCOORD.xy;
    // I.y = iResolution.y - I.y;
    vec4 original_texture = texture(TEXTURE, UV);

    float t = TIME * speed;
    vec4  O = vec4(0.0);
    float z = 0.0;
    float d = 0.0;

    for (int i = 0; i < 100; i++) {
        vec3 p = z * normalize(vec3(I + I, 0.0) - iResolution.xyy);

        vec4 c = cos((z + t) * 0.1 + vec4(0.0, 33.0, 11.0, 0.0));
        p.xy *= mat2(c.xy, c.zw);

        p.z -= 5.0 * t;

        // было: for (d = 1.0; d < 9.0; d /= 0.7) p += cos(p.yzx * d + t) / d;
        {
            float k = 1.0;
            while (k < 9.0) {
                p += cos(p.yzx * k + t) / k;
                k /= 0.7;
            }
        }

        // было: z += d = 0.02 + abs(...) / 8.0;
        d = 0.02 + abs(2.0 - dot(cos(p), sin(p.yzx * 0.6))) / 8.0;
        z += d;

        O += vec4(1.2, 1.0, 0.2, 1.0) * (z / 7.0) / d;
    }

    O = tanh(O * O / 1e7);
    COLOR.rgb = O.rgb * original_texture.a;
    COLOR.rgb = vec3(1.0) - O.rgb;
    COLOR.a = original_texture.a;
}