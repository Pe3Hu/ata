shader_type canvas_item;

// --- Радарные параметры (из вашего примера) ---
uniform float circle_width : hint_range(0.0, 1.0, 0.05) = 0.25; // ширина светящейся полосы
uniform float wait_time : hint_range(0.0, 5.0, 0.1) = 0.2;      // пауза между сканированиями
uniform float speed : hint_range(0.0, 10.0, 0.1) = 0.4;         // базовая скорость сканирования
uniform float alpha_boost : hint_range(1.0, 5.0, 0.1) = 2.0;    // усиление яркости

// --- Асинхронность кругов ---
uniform float async_origin_offset : hint_range(0.0, 5.0, 0.1) = 0.25;
uniform float async_phase_offset : hint_range(0.0, 5.0, 0.1) = 0.25; // сдвиг фазы между кругами
uniform float async_speed_factor : hint_range(0.0, 1.0, 0.05) = 0.1; // изменение скорости для каждого круга

// --- Геометрия расположения ---
uniform float aspect_ratio = 1.0;                                // соотношение сторон экрана (ширина/высота)
uniform float center_offset : hint_range(0.0, 1.0) = 0.5;        // 0 = центр, 0.5 = середина диагонали, 1 = угол
uniform float circle_radius : hint_range(0.01, 1.0) = 0.25;      // радиус круга (в долях высоты экрана)

void fragment() {
    // Переходим к координатам с центром (0,0) и корректируем аспект,
    // чтобы круги оставались круглыми на любом экране.
    vec2 p = (UV - 0.5) * vec2(aspect_ratio, 1.0);

    // Базовое смещение для центров кругов
    vec2 base = center_offset * vec2(0.5 * aspect_ratio, 0.5);

    // Четыре центра (симметрично по диагоналям)
    vec2 centers[4];
    centers[0] = vec2( base.x,  base.y); // правый верхний
    centers[1] = vec2(-base.x,  base.y); // левый верхний
    centers[2] = vec2( base.x, -base.y); // правый нижний
    centers[3] = vec2(-base.x, -base.y); // левый нижний

    float alpha = 0.0;
    vec3 color = vec3(1.0); // цвет волны (можно сделать uniform)

    // Проверяем, в какой из кругов попала текущая точка
    for (int i = 0; i < 4; i++) {
        vec2 diff = p - centers[i];
        float dist = length(diff);

        if (dist <= circle_radius) {
            // --- Индивидуальный ритм для i-го круга ---
            // Скорость этого круга отличается от базовой
            float speed_i = speed * (1.0 + async_speed_factor * float(i));
            // Фаза сдвигается для каждого круга
            float phase = TIME * speed_i + async_origin_offset + async_phase_offset * float(i);

            // Радарная развёртка (как в исходном примере, но с индивидуальной фазой)
            float mod_dist = dist - mod(phase, circle_radius + wait_time) + circle_radius;

            float radar = 1.0 - step(circle_radius, mod_dist);
            radar += step(circle_radius - circle_width / 2.0, mod_dist) - 1.0;
            radar -= 2.0 * dist;   // затухание с расстоянием
            radar *= alpha_boost;

            alpha = clamp(radar, 0.0, 1.0);

            // Плавное появление на границе круга
            float edge = smoothstep(circle_radius, circle_radius - 0.02, dist);
            alpha *= edge;

            // Выходим, так как круги не пересекаются
            break;
        }
    }

    COLOR = vec4(color, alpha);
}