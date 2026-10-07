shader_type canvas_item;

#define phi 1.6180339887

// Цветовая палитра
vec3 colorize(float its) {
    float x = mod(its * 6.0, 6.0);
    return vec3(
        (x < 4.6) ? smoothstep(4.0, 0.4, x) : smoothstep(0.0, 1.4, x - 4.6),
        (x < 3.9) ? smoothstep(2.2, 0.1, x) : smoothstep(0.0, 2.1, x - 3.9),
        (x < 2.0) ? smoothstep(1.1, 0.0, x) : smoothstep(0.0, 4.0, x - 2.0)
    );
}

// Нелинейное преобразование
void f(in vec2 p, in vec2 offs, out vec2 o) {
    o = vec2(cos(p.x) + offs.x, sin(p.y) + offs.y);
}

void fragment() {
    // Размер экрана в пикселях и соотношение сторон
    vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
    float aspect = screen_size.x / screen_size.y;

    // Восстанавливаем uv как в оригинале Shadertoy
    vec2 uv = vec2((SCREEN_UV.x - 0.5) * aspect + 0.25, SCREEN_UV.y - 1.25) * 2.0;
    vec2 uvo = uv;

    // Итерации
    for (int i = 0; i < 24; i++) {
        float fi = float(i);
        vec2 offs = -uv.yx + vec2(cos(phi * TIME * 0.1), sin(TIME * 0.1) + fi) + uvo;
        f(uv, offs, uv);
    }

    // Динамический цвет
    vec3 col = 0.5 + 0.5 * cos(TIME + uv.xyx + vec3(0.0, 2.0, 4.0));
    col = colorize((col.x + col.y + col.z) * 0.15 - 0.05);

    // Альфа текстуры используется как маска видимости
    float tex_alpha = texture(TEXTURE, UV).a;

    COLOR = vec4(col, tex_alpha);
}