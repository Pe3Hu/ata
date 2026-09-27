shader_type canvas_item;

uniform vec3 pattern_color : source_color = vec3(1.0, 0.9, 0.0); // жёлтый
uniform vec3 border_color  : source_color = vec3(0.0, 0.0, 0.0); // чёрный

uniform float border_width  : hint_range(0.001, 0.5) = 0.15;
uniform float contour_count : hint_range(1.0, 30.0) = 2.0;
uniform float pattern_scale : hint_range(1.0, 20.0) = 2.0;
uniform int   vector_mode   : hint_range(0, 1) = 0;

// Размер «блока» пикселизации в ПИКСЕЛЯХ ЭКРАНА.
// 1 = 1 пиксель экрана.
uniform float pixel_size : hint_range(1.0, 32.0) = 4.0;

const float velocity_x = 0.1;
const float velocity_y = 0.2;

const float mode_2_speed  = 2.5;
const float mode_1_detail = 200.0;
const float mode_1_twist  = 50.0;

const int iterationTime1 = 20;
const int iterationTime2 = 20;

varying vec4 vertex_color;

void vertex() {
    vertex_color = COLOR;
}

float f(vec2 p) {
    return sin(p.x + sin(p.y + TIME * velocity_x))
         * sin(p.y * p.x * 0.1 + TIME * velocity_y);
}

vec4 field(vec2 p, int mode) {
    vec2 vel = vec2(0.0);
    vec2 pos = vec2(0.0);

    if (mode == 0) {
        vec2 ep = vec2(0.05, 0.0);
        vec2 rz = vec2(0.0);

        for (int i = 0; i < iterationTime1; i++) {
            float t0 = f(p);
            float t1 = f(p + ep.xy);
            float t2 = f(p + ep.yx);
            vec2 g = vec2((t1 - t0), (t2 - t0)) / ep.xx;
            vec2 t = vec2(-g.y, g.x);

            p += (mode_1_twist * 0.01) * t + g * (1.0 / mode_1_detail);
            p.x += sin(TIME * mode_2_speed / 10.0) / 10.0;
            p.y += cos(TIME * mode_2_speed / 10.0) / 10.0;
            rz = g;
        }

        vel = rz;
        return vec4(vel, pos);
    }

    if (mode == 1) {
        vec2 ep = vec2(0.05, 0.0);
        vec2 rz = vec2(0.0);

        for (int i = 0; i < iterationTime1; i++) {
            float t0 = f(p);
            float t1 = f(p + ep.xy);
            float t2 = f(p + ep.yx);
            vec2 g = vec2((t1 - t0), (t2 - t0)) / ep.xx;
            vec2 t = vec2(-g.y, g.x);

            p += (mode_1_twist * 0.01) * t + g * (1.0 / mode_1_detail);
            p.x += sin(TIME * mode_2_speed / 10.0) / 10.0;
            p.y += cos(TIME * mode_2_speed / 10.0) / 10.0;
            rz = g;
        }

        vel = rz;

        for (int i = 1; i < iterationTime2; i++) {
            p.x += 0.3 / float(i) * sin(float(i) * 3.0 * p.y + TIME * mode_2_speed) + 0.5;
            p.y += 0.3 / float(i) * cos(float(i) * 3.0 * p.x + TIME * mode_2_speed) + 0.5;
        }

        pos = p;
        return vec4(vel, pos);
    }

    return vec4(0.0);
}

void fragment() {
    // --- Привязка к ЭКРАНУ -------------------------------------------
    // Размер экрана в пикселях.
    vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;

    // Квантуем координаты фрагмента по сетке блоков (в пикселях экрана).
    // Все фрагменты внутри одного блока получают одинаковую позицию,
    // поэтому узор блочный и «приклеен» к экрану, а не к спрайту.
    vec2 block = vec2(max(pixel_size, 1.0));
    vec2 screen_pixel = floor(FRAGCOORD.xy / block) * block + block * 0.5;
    vec2 screen_uv    = screen_pixel / screen_size;

    // Приводим к диапазону [-0.5, 0.5] и делаем узор изотропным
    // (иначе на широком экране круги превратятся в эллипсы).
    float aspect = screen_size.x / screen_size.y;
    vec2 p = screen_uv - 0.5;
    p.x *= aspect;
    p *= pattern_scale;

    vec4 fld = field(p, vector_mode);
    vec2 v = (vector_mode == 0) ? fld.xy : fld.zw;

    float s = length(v);
    s = clamp(s, 0.0, 1.0);

    float bands = s * contour_count;
    float contour_pos = abs(fract(bands) - 0.5) * 2.0;
    float is_border = 1.0 - smoothstep(0.0, border_width, contour_pos);

    vec3 col = mix(pattern_color, border_color, is_border);

    // Альфа берётся из текстуры спрайта (чтобы работала маска/форма).
    float tex_alpha = texture(TEXTURE, UV).a;

    COLOR = vec4(col, tex_alpha) * vertex_color;
}