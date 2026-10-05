# CONTENT-11 Biome / Source
**Статус:** черновик
**Источники:** [entities/isle/biome/biome_data.gd](../../entities/isle/biome/biome_data.gd), [entities/isle/biome/source/source_data.gd](../../entities/isle/biome/source/source_data.gd), [entities/isle/biome/source/](../../entities/isle/biome/source/), [global/Bozo.gd](../../global/Bozo.gd) (`enum Biome`)

## Назначение
Схема биомов и Source Resource (plain/swamp/mountain `.tres` — данные, не схема).

## Ключевые сущности / шаги
- `BiomeData` (RefCounted-паттерн).
- `SourceData` extends `Resource`.
- Enum: PLAIN / SWAMP / MOUNTAIN.

## Связи
- [CONTENT-10](CONTENT-10-mainland-types.md), [SYS-10](../systems/SYS-10-mainland-navigation.md)
- [TECH-03](../tech/TECH-03-data-pattern.md)

## TODO / открытые вопросы
- Где BiomeData инстанцируется в рантайме — TODO call-sites.
