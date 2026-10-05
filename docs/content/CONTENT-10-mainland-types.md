# CONTENT-10 Mainland: Structure / Shelter / Trod / Route / Footprint / Haze
**Статус:** черновик
**Источники:** [entities/continent/mainland/](../../entities/continent/mainland/), [entities/continent/haze/](../../entities/continent/haze/), [global/Bozo.gd](../../global/Bozo.gd) (`Structure`, `Trod`, `Terrain`, `Footprint`)

## Назначение
Схема типов карты континента.

## Ключевые сущности / шаги
- Map: `MainlandData`, `ClusterData`, `WastelandData`.
- Nodes: `ShelterData`, `StructureData` + Mine/Ruin/Rift/Shrine.
- Paths: `TrodData`, `RouteData`, `FootprintData`, `MagistralData`.
- Vision: `BeamData`, `HazeData`.

## Связи
- [SYS-10](../systems/SYS-10-mainland-navigation.md), [FLOW-06](../flows/FLOW-06-mainland-travel.md)
- [CONTENT-09](CONTENT-09-guild-types.md), [CONTENT-11](CONTENT-11-biome-source.md)

## TODO / открытые вопросы
- Различия Mine/Ruin/Rift полей — тонкие data-файлы.
