shader_type canvas_item;

// === Базовый цвет палитры (HSV) ===
uniform float base_hue = 0.558;          // 0-1
uniform float base_saturation = 0.558;   // 0-1
uniform float base_value = 0.62;         // 0-1

// === Флаг серого режима ===
uniform bool use_grayscale = false;      // true = только оттенки серого

// === Смещения для каждого цвета относительно базового ===
// Оттенок (в градусах)
uniform float offset_hue_negro_fondo = -31.3;
uniform float offset_hue_morado_osc  = -14.4;
uniform float offset_hue_morado_med  = -5.1;
uniform float offset_hue_purpura     =  0.0;
uniform float offset_hue_neon_claro  =  25.1;
uniform float offset_hue_destello    =  14.7;

// Насыщенность (смещение)
uniform float offset_sat_negro_fondo = 0.201; // 0.759 - base_saturation
uniform float offset_sat_morado_osc  = 0.161; // 0.719 - 0.558
uniform float offset_sat_morado_med  = 0.154; // 0.712 - 0.558
uniform float offset_sat_purpura     = -0.050; // 0.508 - 0.558
uniform float offset_sat_neon_claro  = 0.0;    // 0.558 - 0.558
uniform float offset_sat_destello    = -0.122; // 0.436 - 0.558

// Яркость (смещение)
uniform float offset_val_negro_fondo = -0.475; // 0.145 - 0.62
uniform float offset_val_morado_osc  = -0.146; // 0.474 - 0.62
uniform float offset_val_morado_med  = -0.036; // 0.584 - 0.62
uniform float offset_val_purpura     = 0.0;    // 0.62 - 0.62
uniform float offset_val_neon_claro  = 0.176;  // 0.796 - 0.62
uniform float offset_val_destello    = 0.172;  // 0.792 - 0.62

// === Вспомогательные функции ===
mat2 rot(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(vec2(c, s), vec2(-s, c));
}

float hash(vec2 p) { 
    return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); 
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 x) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    mat2 rot2 = rot(0.5);
    for (int i = 0; i < 5; ++i) {
        v += a * noise(x);
        x = rot2 * x * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

// Преобразование HSV → RGB (hue в градусах)
vec3 hsv2rgb(vec3 hsv) {
    float h = hsv.x * 3.14159265 / 180.0;
    float s = hsv.y;
    float v = hsv.z;
    float c = v * s;
    float x = c * (1.0 - abs(mod(h / (2.0 * 3.14159265 / 6.0), 2.0) - 1.0));
    float m = v - c;
    vec3 rgb;
    if (h < 1.04719755) {
        rgb = vec3(c, x, 0.0);
    } else if (h < 2.0943951) {
        rgb = vec3(x, c, 0.0);
    } else if (h < 3.14159265) {
        rgb = vec3(0.0, c, x);
    } else if (h < 4.1887902) {
        rgb = vec3(0.0, x, c);
    } else if (h < 5.23598776) {
        rgb = vec3(x, 0.0, c);
    } else {
        rgb = vec3(c, 0.0, x);
    }
    return rgb + vec3(m);
}

// Функция получения цвета по смещениям (вынесена на верхний уровень)
vec3 get_color(float offset_hue, float offset_sat, float offset_val) {
    if (use_grayscale) {
        // Серый режим: насыщенность = 0, яркость = base_value + offset_val
        float val = clamp(base_value + offset_val, 0.0, 1.0);
        return hsv2rgb(vec3(0.0, 0.0, val));
    } else {
        float hue = mod(base_hue * 360.0 + offset_hue, 360.0);
        float sat = clamp(base_saturation + offset_sat, 0.0, 1.0);
        float val = clamp(base_value + offset_val, 0.0, 1.0);
        return hsv2rgb(vec3(hue, sat, val));
    }
}

void fragment() {
    vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
    float aspect = screen_size.x / screen_size.y;

    vec2 p = (SCREEN_UV - 0.5) * vec2(aspect, 1.0);
    float t = TIME * 0.08;

    vec2 q = vec2(
        fbm(p * 2.0 + vec2(0.0, t)),
        fbm(p * 2.0 + vec2(1.0, t))
    );
    vec2 r = vec2(
        fbm(p * 2.0 + q + vec2(1.7, 9.2) + 0.15 * t),
        fbm(p * 2.0 + q + vec2(8.3, 2.8) + 0.126 * t)
    );
    float f = fbm(p * 1.5 + r);

    // Получаем все цвета палитры
    vec3 cNegroFondo = get_color(offset_hue_negro_fondo, offset_sat_negro_fondo, offset_val_negro_fondo);
    vec3 cMoradoOsc  = get_color(offset_hue_morado_osc,  offset_sat_morado_osc,  offset_val_morado_osc);
    vec3 cMoradoMed  = get_color(offset_hue_morado_med,  offset_sat_morado_med,  offset_val_morado_med);
    vec3 cPurpura    = get_color(offset_hue_purpura,     offset_sat_purpura,     offset_val_purpura);
    vec3 cNeonClaro  = get_color(offset_hue_neon_claro,  offset_sat_neon_claro,  offset_val_neon_claro);
    vec3 cDestello   = get_color(offset_hue_destello,    offset_sat_destello,    offset_val_destello);

    // Построение градиента
    vec3 color = mix(cNegroFondo, cMoradoOsc, smoothstep(0.1, 0.6, f));
    color = mix(color, cMoradoMed, smoothstep(0.4, 0.8, f));
    color = mix(color, cPurpura, smoothstep(0.6, 1.0, f));
    color = mix(color, cNeonClaro, pow(f, 3.0) * 0.8);

    float spark = pow(fbm(p * 6.0 - t * 2.0), 4.0);
    color += cDestello * spark * 0.4;

    vec2 uvVignette = SCREEN_UV;
    float vignette = uvVignette.x * uvVignette.y * (1.0 - uvVignette.x) * (1.0 - uvVignette.y);
    color *= clamp(pow(16.0 * vignette, 0.25), 0.0, 1.0);

    float tex_alpha = texture(TEXTURE, UV).a;
    COLOR = vec4(color, tex_alpha);
}