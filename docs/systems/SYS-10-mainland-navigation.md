# SYS-10 Mainland / навигация
**Статус:** черновик
**Источники:** [entities/continent/mainland/](../../entities/continent/mainland/), [entities/continent/haze/](../../entities/continent/haze/), [entities/continent/continent.gd](../../entities/continent/continent.gd), [global/Mother.gd](../../global/Mother.gd), [global/Helper.gd](../../global/Helper.gd)

## Назначение
Карта континента: clusters/tilemap, shelters, structures, trods/routes/footprint travel, beam, haze fog.

## Ключевые сущности / шаги
- `Mother.mainland: MainlandData`.
- `Mainland` строит визуал; helpers геометрии в `Helper`.
- `RouteData`: `trods_updated`, `selected_type_changed`; задаёт `Mother.guild.structure`.
- `FootprintData`: `route_finished`, `structures_changed`.
- `BeamData.shelters_changed`; `ShrineData` → haze/illuminate; `HazeData.changed`.
- `Continent.gd` — почти пустой stub (`extends Control`).

## Связи
- [SYS-09](SYS-09-guild-masters-agents.md)
- [CONTENT-10](../content/CONTENT-10-mainland-types.md)
- [FLOW-05](../flows/FLOW-05-home-isle-continent.md), [FLOW-06](../flows/FLOW-06-mainland-travel.md)
- [TECH-06](../tech/TECH-06-scene-tree.md)

## TODO / открытые вопросы
- Генерация/сид mainland при старте — детали второго прохода.
- `marker.gd` / `mainland_panel.gd` / `camera.gd` без class_name.
