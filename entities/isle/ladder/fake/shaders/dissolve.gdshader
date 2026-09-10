shader_type canvas_item;

uniform sampler2D dissolve_texture : source_color;
uniform float dissolve_value : hint_range(0, 1) = 1.0;
uniform float burn_size: hint_range(0.0, 1.0, 0.01) = 0.15;
uniform vec4 burn_color: source_color;

void fragment(){
    vec4 main_texture = texture(TEXTURE, UV);
    vec4 noise_texture = texture(dissolve_texture, UV);

    // Применяем modulate (COLOR) к основной текстуре
    vec4 modulated_texture = main_texture * COLOR;

    float burn_size_step = burn_size * step(0.001, dissolve_value) * step(dissolve_value, 0.999);
    float threshold = smoothstep(noise_texture.x - burn_size_step, noise_texture.x, dissolve_value);
    float border = smoothstep(noise_texture.x, noise_texture.x + burn_size_step, dissolve_value);

    COLOR.a = modulated_texture.a * threshold;
    COLOR.rgb = mix(burn_color.rgb, modulated_texture.rgb, border);
}