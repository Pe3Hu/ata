shader_type canvas_item;

// Два цвета для градиента
uniform vec4 color1 : source_color = vec4(0.73, 0.24, 0.5, 1.0);
uniform vec4 color2 : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    // Используем экранные координаты (0..1 по всему экрану)
    vec2 uv = 6.0 * SCREEN_UV;
    
    for (int n = 1; n < 20; n++) {
        float i = float(n);
        uv += vec2(
            1.0 / i * sin(i * uv.y + i * TIME / 10.0) + 0.8,
            1.0 / i * sin(uv.x + i * TIME / 10.0) + 1.6
        );
    }
    
    // Фактор градиента на основе cos(uv.x + uv.y)
    float t = cos(uv.x + uv.y) * 0.5 + 0.5; // приводим к диапазону 0..1
    vec3 color = mix(color1.rgb, color2.rgb, t);
    
    // Сохраняем альфа-канал текстуры (прозрачность там, где текстура отсутствует)
    float alpha = texture(TEXTURE, UV).a;
    
    COLOR = vec4(color, alpha);
}