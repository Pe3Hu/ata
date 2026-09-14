shader_type canvas_item;
render_mode unshaded;

// Шумовая текстура (NoiseTexture2D или любая другая). Задаётся из GDScript/инспектора.
uniform sampler2D iChannel1 : hint_default_black;

// Мягкость кромки засветки. 0 = жёсткий пиксельный край.
uniform float reveal_softness : hint_range(0.0, 1.0) = 0.00;

// Общая непрозрачность тумана
uniform float fog_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float animation_speed : hint_range(0.0, 5.0) = 0.3;
uniform float hue : hint_range(0.0, 1.0) = 0.6;

vec4 permute(vec4 x) { return mod(x * x * 34.0 + x, 289.0); }

float noise3(vec3 v) {
    v *= 64.0 / 2.0;
    const vec2 C = 1.0 / vec2(6.0, 3.0);
    const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);
    vec3 i = floor(v + dot(v, C.yyy));
    vec3 x0 = v - i + dot(i, C.xxx);
    vec3 g = step(x0.yzx, x0);
    vec3 l = 1.0 - g.zxy;
    vec3 i1 = min(g, l);
    vec3 i2 = max(g, l);
    vec3 x1 = x0 - i1 + C.x;
    vec3 x2 = x0 - i2 + C.y;
    vec3 x3 = x0 - D.yyy;
    i = mod(i, 289.0);
    vec4 p = permute(permute(permute(
        i.z + vec4(0.0, i1.z, i2.z, 1.0))
        + i.y + vec4(0.0, i1.y, i2.y, 1.0))
        + i.x + vec4(0.0, i1.x, i2.x, 1.0));
    vec3 ns = 0.142857142857 * D.wyz - D.xzx;
    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);
    vec4 x_ = floor(j * ns.z);
    vec4 x = x_ * ns.x + ns.yyyy;
    vec4 y = floor(j - 7.0 * x_) * ns.x + ns.yyyy;
    vec4 h = 1.0 - abs(x) - abs(y);
    vec4 b0 = vec4(x.xy, y.xy);
    vec4 b1 = vec4(x.zw, y.zw);
    vec4 sh = -step(h, vec4(0.0));
    vec4 a0 = b0.xzyw + (floor(b0) * 2.0 + 1.0).xzyw * sh.xxyy;
    vec4 a1 = b1.xzyw + (floor(b1) * 2.0 + 1.0).xzyw * sh.zzww;
    vec3 p0 = vec3(a0.xy, h.x);
    vec3 p1 = vec3(a0.zw, h.y);
    vec3 p2 = vec3(a1.xy, h.z);
    vec3 p3 = vec3(a1.zw, h.w);
    vec4 norm = inversesqrt(vec4(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;
    vec4 m = max(0.6 - vec4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
    return 0.5 + 12.0 * dot(m * m * m, vec4(dot(p0, x0), dot(p1, x1), dot(p2, x2), dot(p3, x3)));
}

float noise2(vec2 v) {
    return noise3(vec3(v, 0.01 * TIME * animation_speed));
}

void fragment() {
    // --- 1. Засветка ---------------------------------------------------
    // R-канал fog_image = «исследованность» (0 = туман, 1 = территория).
    float revealed = texture(TEXTURE, UV).r;
    float alpha = 1.0 - smoothstep(0.0, max(reveal_softness, 1e-4), revealed);
    alpha *= fog_opacity;

    // Полностью открытые пиксели не рисуем — экономим fillrate.
    if (alpha <= 0.001) {
        discard;
    }

    // --- 2. Пикселизация ----------------------------------------------
    // Работаем в координатах fog-пикселей, а не экрана.
    // floor(UV / TEXTURE_PIXEL_SIZE) + 0.5 — центр текущего fog-пикселя;
    // все фрагменты внутри одного fog-пикселя получают одинаковые значения,
    // поэтому картинка блочная и привязана к миру, а не к экрану.
    vec2 fog_pixel = floor(UV / TEXTURE_PIXEL_SIZE) + 0.5;
    vec2 R = 1.0 / TEXTURE_PIXEL_SIZE;   // размер fog_image в пикселях

    // --- 3. Flow-field (оригинальная логика) --------------------------
	float t = TIME * animation_speed;
    const float N = 30.0;

    vec2 U = vec2(fog_pixel.x, R.y - fog_pixel.y);   // Y-flip
    U /= 8.0 * R.y;

    vec2 D, P0 = U, P = P0;
    vec4 O = vec4(0.0);

    for (float i = 0.0; i < 1.0; i += 1.0 / N) {
        float T = noise2(P);
        float dnoise_x = T - noise2(P - vec2(1.0, 0.0) / 8.0 / R.y);
        float dnoise_y = T - noise2(P - vec2(0.0, 1.0) / 8.0 / R.y);
        D = vec2(dnoise_x, dnoise_y);
        D = normalize(D) * 5.0 / R.y;
        D = vec2(-D.y, D.x);

        P -= 0.1 / 200.0 * D * R.y / 8.0;

        vec2 uvTex = P.xy * 8.0 * R.y / R + vec2(0.00 * t);
        float texVal = texture(iChannel1, uvTex).r;

        O += (0.5 + 0.5 * vec4(P - P0, 0.0, 0.0) * 200.0 * 8.0 / 11.3)
            * pow(texVal * 1.15, 3.0) * 2.0
            * (1.0 + 1.0 * sin(2.0 * 6.2832 * i + 10.0 * t));
    }
    O /= N;

    float gray = dot(O.rgb, vec3(0.2126, 0.7152, 0.0722));
	gray = pow(clamp(gray, 0.0, 1.0), 0.85);

	float h = hue * 6.0;
	float x = 1.0 - abs(mod(h, 2.0) - 1.0);

	vec3 hue_color;

	if (h < 1.0) {
	    hue_color = vec3(1.0, x, 0.0);
	} else if (h < 2.0) {
	    hue_color = vec3(x, 1.0, 0.0);
	} else if (h < 3.0) {
	    hue_color = vec3(0.0, 1.0, x);
	} else if (h < 4.0) {
	    hue_color = vec3(0.0, x, 1.0);
	} else if (h < 5.0) {
	    hue_color = vec3(x, 0.0, 1.0);
	} else {
	    hue_color = vec3(1.0, 0.0, x);
	}

	vec3 color = hue_color * gray;

	COLOR = vec4(color, alpha);
}