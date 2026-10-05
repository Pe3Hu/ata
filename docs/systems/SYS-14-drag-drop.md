# SYS-14 Drag-drop grid
**Статус:** stub
**Источники:** [entities/drag drop/grid/grid.gd](../../entities/drag%20drop/grid/grid.gd), [entities/drag drop/cell/cell.gd](../../entities/drag%20drop/cell/cell.gd)

## Назначение
Универсальный виджет сетки drag-drop: ячейки реэмитят `dragged(from, to)`.

## Ключевые сущности / шаги
- `DragDropGrid` / `DragDropCell`.
- Сигнал `dragged(from: Vector2i, to: Vector2i)`.

## Связи
- [TECH-06](../tech/TECH-06-scene-tree.md), [TECH-08](../tech/TECH-08-shared-ui-json.md)

## TODO / открытые вопросы
- Кто инстанцирует/слушает grid — TODO: не найдено.
