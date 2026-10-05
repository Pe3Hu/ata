# TECH-08 Shared UI / JSON
**Статус:** черновик
**Источники:** [shared/buttons/custom button.gd](../../shared/buttons/custom%20button.gd), [shared/labels/defaul label.tres](../../shared/labels/defaul%20label.tres), [shared/jsons/names.json](../../shared/jsons/names.json), [shared/jsons/totems.json](../../shared/jsons/totems.json), [global/Helper.gd](../../global/Helper.gd)

## Назначение
Общие UI-ресурсы и JSON-данные вне entities.

## Ключевые сущности / шаги
- `CustomButton` (TextureButton + hover/press scale tweens).
- LabelSettings `defaul label.tres` + font из project.godot `gui/theme/custom_font`.
- `Helper.get_random_names` читает `names.json`.
- `totems.json` присутствует; ссылок из `global/*.gd` нет.

## Связи
- [SYS-14](../systems/SYS-14-drag-drop.md), [TECH-01](TECH-01-autoloads.md)
- [SYS-09](../systems/SYS-09-guild-masters-agents.md) (имена рекрутов)

## TODO / открытые вопросы
- Consumer `totems.json` — TODO: не найдено в global.
