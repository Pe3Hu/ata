shader_type canvas_item;

// ====== Настраиваемые параметры ======

// Количество сегментов (полос) вдоль оси. Было жёстко зашито как COORDS_SCALE = 10.0
uniform float segments : hint_range(1.0, 100.0) = 10.0;

// Размер ноды, к которой привязан материал (в пикселях).
// Задаётся из GDScript — см. пример ниже.
// Нужен, чтобы рисунок масштабировался относительно ноды, а не экрана.
uniform vec2 node_size = vec2(1024.0, 1024.0);

// Во сколько раз "1 единица" паттерна больше 1 пикселя.
// Меньше — плотнее рисунок, больше — крупнее.
uniform float pixel_unit = 100.0;

// ====== Константы (как в оригинале) ======
const float OFFSET       = 0.7;
const float WAVE_OFFSET  = 0.6;
const float SCALE        = 0.3;
const float WAVE_SCALE   = 0.4;

const float WAVE_FREQ    = 2.0;
const float WAVE_SPEED   = 0.5;

const vec3  NEAR_COLOR   = vec3(0.75, 0.65, 0.3);
const vec3  FAR_COLOR    = vec3(0.55, 0.33, 0.1);
const float TIME_SCALE   = 0.05;

void fragment() {
    vec2 uv = UV;

    // Привязка к размеру ноды: переводим UV (0..1) в пиксельные координаты ноды,
    // затем нормируем на pixel_unit и масштабируем на число сегментов.
    vec2 coords = (uv * node_size / pixel_unit) * (segments / 10.0);

    float t = TIME * TIME_SCALE * 20.0;

    // === Направление волны: СЛЕВА → НАПРАВО ===
    // В оригинале было "+ WAVE_SPEED * iTime" и "+ sin(...)",
    // что давало движение справа-налево. Меняем знаки на минус:
    float var = coords.x + coords.y
              - WAVE_SPEED * t
              + WAVE_OFFSET
              + WAVE_SCALE * sin(coords.x - WAVE_FREQ * t);

    float f = fract(var);

    // Анти-алиасинг краёв
    float coeff = OFFSET
                + SCALE * smoothstep(0.0, 1.0, f)
                - SCALE * smoothstep(0.97, 1.0, f);

    vec3 res = mix(NEAR_COLOR, FAR_COLOR, uv.x + uv.y) * coeff;
    COLOR = vec4(res, 1.0);
}