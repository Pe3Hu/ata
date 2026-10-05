# FLOW-06 Mainland travel
**Статус:** черновик
**Источники:** [entities/continent/mainland/trod/](../../entities/continent/mainland/trod/), [entities/continent/mainland/beam/](../../entities/continent/mainland/beam/), [entities/continent/haze/](../../entities/continent/haze/)

## Назначение
Выбор маршрута на карте, анимация footprint, обновление structures/haze/beam.

## Ключевые сущности / шаги
1. Выбор типа/троп — `RouteData` (`trods_updated`, `selected_type_changed`).
2. Установка `Mother.guild.structure` из route.
3. `Footprint` travel → `route_finished` / `structures_changed`.
4. Shrine illuminate ↔ haze; beam ↔ shelters graph.

## Связи
- [SYS-10](../systems/SYS-10-mainland-navigation.md), [SYS-09](../systems/SYS-09-guild-masters-agents.md)
- [CONTENT-10](../content/CONTENT-10-mainland-types.md)
- [FLOW-05](FLOW-05-home-isle-continent.md), [FLOW-07](FLOW-07-guild-task-agent.md)

## TODO / открытые вопросы
- Условия блокировки маршрутов / overtime travel — уточнить в footprint/calendar.
