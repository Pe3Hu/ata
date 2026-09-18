shader_type canvas_item;


// Цвет сияния (можно менять из инспектора)
uniform vec3 shine_color : source_color = vec3(0.4, 0.8, 1.0);
// Общая яркость сияния
uniform float shine_brightness : hint_range(0.0, 4.0) = 1.0;
// Пикселизация: сколько "пикселей" по высоте текстуры (меньше = грубее)
uniform float pixel_size : hint_range(4.0, 1024.0) = 16.0;

void fragment() {
    // --- Легкая пикселизация ---
    // Округляем UV к сетке пикселей, сохраняя пропорции текстуры
    vec2 tex_size = 1.0 / TEXTURE_PIXEL_SIZE;      // размер текстуры в пикселях
    vec2 grid = vec2(tex_size.x / tex_size.y, 1.0) * pixel_size;
    vec2 puv = (floor(UV * grid) + 0.5) / grid;    // квантованные UV

    // --- Как в оригинале, но по квантованным UV ---
    float aspect = TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;
    vec2 uv = (puv - 0.5) * vec2(aspect, -1.0);

    float t = TIME;

    float radial = atan(uv.x, uv.y) / (PI * 2.0);

    float shine1 = abs(fract((radial + t *  0.12) *  2.0) - 0.5) * 2.0;
    float shine2 = abs(fract((radial + t * -0.06) *  5.0) - 0.5) * 2.0;
    float shine3 = abs(fract((radial + t *  0.001) * 11.0) - 0.5) * 2.0;

    float shines = 0.0;
    shines += shine1 * 0.13;
    shines += shine2 * 0.23;
    shines += shine3 * 0.33;
    shines = smoothstep(0.2, 0.5, shines);

    float luv = length(uv);

    shines = shines * (0.12 / luv);
    shines = clamp(shines, 0.0, 1.0) * smoothstep(0.03, 0.25, luv);
    shines *= smoothstep(1.0, 0.0, luv);
    shines = clamp(shines, 0.0, 1.0);

    float intensity = mix(shines, 1.0, smoothstep(0.4, 0.0, luv)) * shine_brightness;
    intensity = clamp(intensity, 0.0, 1.0);

    // Цвет сияния: в ядре (intensity = 1) подмешиваем белый, чтобы центр был "горячим"
    vec3 col = mix(shine_color, vec3(1.0), smoothstep(0.6, 1.0, intensity));

    // Чёрный фон → прозрачный
    COLOR = vec4(col * intensity, intensity);
}