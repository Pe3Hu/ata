shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4  fill_color : source_color = vec4(1.0, 0.65, 0.15, 1.0);

// 0 = слева-направо, сверху-вниз
// 1 = слева-направо, снизу-вверх
// 2 = по столбцам, снизу-вверх
uniform int  fill_order   : hint_range(0, 2) = 1;
uniform bool partial_fill = true;

const vec2  TOTAL = vec2(104.0, 102.0);
const vec2  CELL  = vec2(16.0,  18.0);
const ivec2 GRID  = ivec2(5, 5);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    vec2 px      = UV * TOTAL;
    vec2 step_px = (TOTAL - CELL) / vec2(float(GRID.x - 1), float(GRID.y - 1));

    // Ячейка сетки, в чей "слот" попал пиксель (без округления!)
    int cc = int(floor(px.x / step_px.x));
    int rr = int(floor(px.y / step_px.y));
    cc = clamp(cc, 0, GRID.x - 1);
    rr = clamp(rr, 0, GRID.y - 1);

    // Локальные координаты внутри bbox этой ячейки
    vec2 org   = vec2(float(cc), float(rr)) * step_px;
    vec2 local = px - org;

    // Пиксель лежит внутри bbox ячейки? Иначе он в зазоре → невидим.
    bool in_cell = local.x >= 0.0 && local.x < CELL.x
                && local.y >= 0.0 && local.y < CELL.y;

    // Индекс в порядке заполнения
    int idx;
    if (fill_order == 0) {
        idx = rr * GRID.x + cc;
    } else if (fill_order == 1) {
        idx = (GRID.y - 1 - rr) * GRID.x + cc;
    } else {
        idx = cc * GRID.y + (GRID.y - 1 - rr);
    }

    float total_cells = float(GRID.x * GRID.y);
    float cell_start  = float(idx) / total_cells;
    float cell_end    = float(idx + 1) / total_cells;

    // 0.0 — пусто, 1.0 — залито
    float filled = 0.0;
    if (progress >= cell_end) {
        filled = 1.0;
    } else if (partial_fill && progress > cell_start) {
        float p = (progress - cell_start) / (cell_end - cell_start);
        filled = step(CELL.y * (1.0 - p), local.y); // снизу вверх
    }

    // Зазор → принудительно невидим.
    if (!in_cell) {
        filled = 0.0;
    }

    // Пустое / зазор → alpha = 0. Залитое → цвет заливки × силуэт текстуры.
    COLOR = vec4(tex.rgb * fill_color.rgb,
                 tex.a * fill_color.a * filled);
}