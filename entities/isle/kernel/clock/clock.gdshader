shader_type canvas_item;
render_mode unshaded;

// Угол поворота секундной стрелки в радианах (0 = 12 часов, по часовой).
uniform float hand_angle = 0.0;

// Длина передней части стрелки (той, что указывает на цифры).
uniform float hand_length : hint_range(0.3, 1.5, 0.01) = 0.7;

// Радиальное смещение римских цифр (0.10 — ближе к центру, 0.20 — к краю).
uniform float rome_offset : hint_range(0.1, 0.2, 0.01) = 0.15;

// Масштаб циферблата. 2.42 — вписан в квадрат с запасом 1 px.
uniform float clock_scale : hint_range(2.0, 2.5, 0.01) = 2.4;

// Цвета
uniform vec4 numbers_color        : source_color = vec4(0.0, 0.0, 0.0, 1.0); // обычные цифры
uniform vec4 numbers_color_active : source_color = vec4(1.0, 1.0, 1.0, 1.0); // цифра в секторе стрелки
uniform vec4 hand_fill_color      : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 hand_border_color    : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// Выставляется из скрипта: = size ColorRect
uniform vec2 resolution = vec2(360.0, 360.0);

#define HALFPI  1.57079632679

#define EMPTY   vec4(0.0)

vec2 rotateUV(vec2 uv, vec2 pivot, float angle)
{
	float x = cos(angle) * (uv.x - pivot.x) + sin(angle) * (uv.y - pivot.y) + pivot.x;
	float y = cos(angle) * (uv.y - pivot.y) - sin(angle) * (uv.x - pivot.x) + pivot.y;
	return vec2(x, y);
}

float sdParallelogram(in vec2 p, float wi, float he, float sk)
{
	vec2 e = vec2(sk, he);
	float e2 = sk * sk + he * he;
	p = (p.y < 0.0) ? -p : p;
	vec2 w = p - e;
	w.x -= clamp(w.x, -wi, wi);
	vec2 d = vec2(dot(w, w), -w.y);
	float s = p.x * e.y - p.y * e.x;
	p = (s < 0.0) ? -p : p;
	vec2 v = p - vec2(wi, 0.0);
	v -= e * clamp(dot(v, e) / e2, -1.0, 1.0);
	d = min(d, vec2(dot(v, v), wi * he - abs(s)));
	return sqrt(d.x) * sign(-d.y);
}

float sdBox(in vec2 uv, in vec2 pos, in vec2 size, float angle)
{
	uv -= pos;
	uv = rotateUV(uv, vec2(0.0), angle);
	vec2 d = abs(uv) - size;
	return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float sdRhombus(vec2 st, vec2 pos, vec2 size, float angle)
{
	st -= pos;
	st = rotateUV(st, vec2(0.0), angle);
	st = abs(st);
	st.x -= size.x;
	float f = clamp((st.y - st.x) / (size.y + size.x), 0.0, 1.0);
	vec2 q = abs(st - f * vec2(-size.x, size.y));
	return max(q.x, q.y) * ((size.y * st.x + size.x * st.y > 0.0) ? 1.0 : -1.0);
}

float romanNumerals(vec2 uv, vec2 pos, vec2 size, float angle, int num)
{
	float n = 1.0;
	uv -= pos;
	uv /= size;
	uv = rotateUV(uv, vec2(0.0), -HALFPI + angle);

	if (num == 1) {
		n = sdBox(uv, vec2(0.0), vec2(0.35, 2.0), 0.0);
	} else if (num == 2) {
		n = sdBox(uv, vec2(-0.6, 0.0), vec2(0.35, 2.0), 0.0);
		n = min(n, sdBox(uv, vec2(0.6, 0.0), vec2(0.35, 2.0), 0.0));
	} else if (num == 3) {
		n = sdBox(uv, vec2(-1.2, 0.0), vec2(0.35, 2.0), 0.0);
		n = min(n, sdBox(uv, vec2(0.0), vec2(0.35, 2.0), 0.0));
		n = min(n, sdBox(uv, vec2(1.2, 0.0), vec2(0.35, 2.0), 0.0));
	} else if (num == 4) {
		n = sdBox(uv, vec2(-1.8, 0.0), vec2(0.35, 2.0), 0.0);
		n = min(n, sdParallelogram(uv - vec2(1.2, 0.0), 0.4, 2.0, 0.6));
		n = min(n, sdParallelogram(uv - vec2(0.0, 0.0), 0.4, 2.0, -0.6));
	} else if (num == 5) {
		n = sdParallelogram(uv - vec2(0.6, 0.0), 0.4, 2.0, 0.6);
		n = min(n, sdParallelogram(uv + vec2(0.6, 0.0), 0.4, 2.0, -0.6));
	} else if (num == 6) {
		n = sdBox(uv, vec2(1.8, 0.0), vec2(0.35, 2.0), 0.0);
		n = min(n, sdParallelogram(uv + vec2(0.0, 0.0), 0.4, 2.0, 0.6));
		n = min(n, sdParallelogram(uv + vec2(1.2, 0.0), 0.4, 2.0, -0.6));
	} else if (num == 7) {
		n = sdBox(uv, vec2(1.2, 0.0), vec2(0.35, 2.0), 0.0);
		n = min(n, sdBox(uv, vec2(2.4, 0.0), vec2(0.35, 2.0), 0.0));
		n = min(n, sdParallelogram(uv + vec2(0.6, 0.0), 0.4, 2.0, 0.6));
		n = min(n, sdParallelogram(uv + vec2(1.8, 0.0), 0.4, 2.0, -0.6));
	} else if (num == 8) {
		n = sdBox(uv, vec2(0.6, 0.0), vec2(0.35, 2.0), 0.0);
		n = min(n, sdBox(uv, vec2(1.8, 0.0), vec2(0.35, 2.0), 0.0));
		n = min(n, sdBox(uv, vec2(3.0, 0.0), vec2(0.35, 2.0), 0.0));
		n = min(n, sdParallelogram(uv + vec2(1.2, 0.0), 0.4, 2.0, 0.6));
		n = min(n, sdParallelogram(uv + vec2(2.4, 0.0), 0.4, 2.0, -0.6));
	} else if (num == 9) {
		n = sdBox(uv, vec2(-1.6, 0.0), vec2(0.35, 2.0), 0.0);
		n = min(n, sdParallelogram(uv - vec2(0.6, 0.0), 0.4, 2.0, 1.0));
		n = min(n, sdParallelogram(uv - vec2(0.6, 0.0), 0.4, 2.0, -1.0));
	} else if (num == 10) {
		n = sdParallelogram(uv, 0.4, 2.0, 1.0);
		n = min(n, sdParallelogram(uv, 0.4, 2.0, -1.0));
	} else if (num == 11) {
		n = sdBox(uv, vec2(1.6, 0.0), vec2(0.35, 2.0), 0.0);
		n = min(n, sdParallelogram(uv + vec2(0.6, 0.0), 0.4, 2.0, 1.0));
		n = min(n, sdParallelogram(uv + vec2(0.6, 0.0), 0.4, 2.0, -1.0));
	} else if (num == 12) {
		n = sdBox(uv, vec2(1.0, 0.0), vec2(0.35, 2.0), 0.0);
		n = min(n, sdBox(uv, vec2(2.2, 0.0), vec2(0.35, 2.0), 0.0));
		n = min(n, sdParallelogram(uv + vec2(1.2, 0.0), 0.4, 2.0, 1.0));
		n = min(n, sdParallelogram(uv + vec2(1.2, 0.0), 0.4, 2.0, -1.0));
	}
	return n;
}

vec4 clockNumbers(vec2 uv, vec2 pos, int active_hour)
{
	vec4 layer = EMPTY;
	uv -= pos;
	float n = 0.0;
	uv = rotateUV(uv, vec2(0.0), -1.8155);

	float num = 12.0;
	float angle = (atan(uv.y, uv.x) + PI) / TAU * num;
	float id = floor(angle);
	float baseAngle = id / num * TAU + PI;

	vec2 ruv = rotateUV(uv, vec2(0.0), (baseAngle + 0.245));

	float angleTmp = HALFPI;
	int numTmp = int(num - id);
	if (numTmp > 3 && numTmp < 9) angleTmp = -angleTmp;

	ruv = rotateUV(ruv, vec2(0.2), -HALFPI);

	n = romanNumerals(ruv, vec2(0.4, rome_offset), vec2(0.00915), angleTmp, numTmp);

	// Выбор цвета: если цифра в текущем секторе стрелки — активный цвет.
	vec4 col = (numTmp == active_hour) ? numbers_color_active : numbers_color;

	layer = mix(layer, vec4(col.rgb, 1.0), smoothstep(0.1, 0.0, n) * col.a);
	return layer;
}

// Только секундная стрелка. Угол — из hand_angle, длина передней части — из hand_length.
void clockSecondHand(inout vec4 layer, vec2 st, vec2 pos, vec2 size, float angle_in)
{
	st -= pos;
	st /= size;

	float d = 0.0;
	float angle = -angle_in;
	vec2 suv = rotateUV(st, vec2(0.0), angle);

	float y_top    =  0.85 * hand_length;
	float y_bottom = -0.25;
	float y_center = (y_top + y_bottom) * 0.5;
	float y_half   = (y_top - y_bottom) * 0.5;

	if (abs(suv.x) * size.x > (size.x * 0.07) ||
		abs(suv.y - y_center) * size.y > (size.y * y_half))
	{
		return;
	}

	d = sdRhombus(suv, vec2(0.0, 0.69 * hand_length), vec2(0.05, 0.1), 0.0);

	float body_top    =  0.6625 * hand_length;
	float body_bottom = -0.1375;
	float body_center = (body_top + body_bottom) * 0.5;
	float body_half   = (body_top - body_bottom) * 0.5;

	d = min(d, sdBox(suv, vec2(0.0, body_center), vec2(0.021, body_half), 0.0));

	d = min(d, sdRhombus(suv, vec2(0.0, -0.15), vec2(0.04, 0.08), 0.0));
	d = min(d, length(suv - vec2(0.0)) - 0.05);

	vec4 shLayer = vec4(hand_fill_color.rgb, 1.0);

	layer = mix(layer, vec4(vec3(0.0), 1.0), smoothstep(0.015, 0.0, d) * 0.75);

	const float thickness = 0.015;
	const float fade = 0.005;
	float smoothedAlpha = 1.0 - smoothstep(0.0, fade, d);
	float borderAlpha = 1.0 - smoothstep(thickness - fade, thickness, abs(d));
	vec4 borderColor = hand_border_color;

	layer = mix(layer, mix(shLayer, borderColor, borderAlpha), smoothedAlpha * hand_fill_color.a);
}

// Порядок отрисовки: сначала стрелка, сверху — цифры.
void historicClock(inout vec4 layer, vec2 uv, vec2 pos, float size)
{
	uv -= pos;
	uv.y = -uv.y;

	clockSecondHand(layer, uv / size, vec2(0.0), vec2(0.228), hand_angle);

	// Определяем номер цифры, в чей сектор смотрит стрелка.
	// hand_angle = 0 → 12, дальше по часовой: 1, 2, ..., 11.
	int active_hour = int(mod(round(hand_angle / (TAU / 12.0)), 12.0));
	if (active_hour == 0) active_hour = 12;

	vec2 nuv = uv / size;
	vec4 clockNumbersLayer = clockNumbers(nuv, vec2(0.0), active_hour);
	layer = mix(layer, clockNumbersLayer, clockNumbersLayer.a);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
	vec2 uv = (fragCoord.xy - 0.5 * resolution.xy) / min(resolution.x, resolution.y) + 0.5;

	vec2 pos = vec2(0.5);

	fragColor = vec4(0.0);
	historicClock(fragColor, uv, pos, clock_scale);
}

void fragment()
{
	vec4 fragColor;
	mainImage(fragColor, UV * resolution);
	COLOR = fragColor;
}