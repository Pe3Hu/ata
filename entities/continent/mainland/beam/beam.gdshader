shader_type canvas_item;

uniform float speed : hint_range(0.1, 5.0) = 1.0;
uniform float pixel_resolution : hint_range(2.0, 256.0) = 32.0;
uniform float alpha : hint_range(0.0, 1.0) = 0.95;
uniform float flicker_strength : hint_range(0.0, 0.5) = 0.15;

uniform vec3 to_color   : source_color = vec3(0.4, 0.35, 0.2);
uniform vec3 from_color : source_color = vec3(0.9, 0.2, 0.1);

uniform float particle_count : hint_range(16.0, 512.0) = 128.0;
uniform float brightness : hint_range(0.0001, 0.01) = 0.001;
uniform float fire_shift : hint_range(0.0, 0.5) = 0.15;
uniform float fire_shift_frequency : hint_range(1.0, 10.0) = 5.0;

uniform vec2 size  = vec2(0.05, 1.8);
uniform vec2 glow  = vec2(0.001, 0.04);

uniform float aspect_ratio : hint_range(0.01, 5.0) = 1.0;
uniform vec2 pos_offset = vec2(0.0, -0.75);

uniform float gravity_angle : hint_range(-180.0, 180.0) = 0.0;

float hash_1(float t) {
    return fract(cos(t * 124.97) * 248.842) - 0.5;
}

float saturate(float x) {
    return clamp(x, 0.0, 1.0);
}

vec3 simulate(vec2 uv, float t) {
    vec3 res = vec3(0.0);

    for (float i = 0.0; i < particle_count; i++) {
        float phase = t + (i + 1.0) / particle_count;
        float ct = fract(phase);
        float cycle = floor(phase);

        float seed = hash_1((i + 1.0) * 137.0 + cycle * 41.0);

        vec2 dir = vec2(0.0, size.y);

        dir.x += (cos(t * seed) * sin(ct * fire_shift_frequency))
                 * mix(0.0, fire_shift, log(max(ct, 0.001)));

        float cb = saturate(mix(brightness, 0.0, ct));
        vec2 off = vec2(seed * size.x, 0.0);

        res += mix(from_color * abs(seed), to_color, ct)
             * smoothstep(glow.x, glow.y,
                          cb / length(uv - off - (dir * ct)));
    }
    return res;
}

void fragment() {
    // Пикселизация по сетке: pixel_resolution блоков по короткой стороне UV.
    vec2 grid = vec2(pixel_resolution / aspect_ratio, pixel_resolution);
    vec2 pix_uv = floor(UV * grid) / grid;

    vec2 frag_coords = pix_uv * 2.0 - 1.0;
    frag_coords.x *= aspect_ratio;
    frag_coords.y *= -1.0;

    float ga = radians(gravity_angle);
    float cg = cos(ga);
    float sg = sin(ga);
    frag_coords = vec2(frag_coords.x * cg - frag_coords.y * sg,
                       frag_coords.x * sg + frag_coords.y * cg);

    frag_coords -= pos_offset;

    float base_time = TIME + 100.0;
    vec3 fire_color = simulate(frag_coords, base_time * speed);

    float flicker = (hash_1(base_time * 5.0) + 0.5) * flicker_strength;
    vec3 final_color = fire_color * (1.0 + flicker);

    float intensity = max(max(fire_color.r, fire_color.g), fire_color.b);
    float final_alpha = smoothstep(0.01, 0.5, intensity) * alpha;

    COLOR = vec4(final_color * alpha, final_alpha);
}