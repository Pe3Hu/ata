# CONTENT-04 Odeum / Hymn / Canto / Tune
**Статус:** черновик
**Источники:** [entities/isle/odeum/](../../entities/isle/odeum/), [global/Bozo.gd](../../global/Bozo.gd) (`enum Tune`)

## Назначение
Схема музыкально-сценарных типов odeum.

## Ключевые сущности / шаги
- Data: `OdeumData`, `HymnData`, `CantoData`, `TuneData`; UI Pulse.
- `CantoData` сигналы pulse/perfect/selected/voice_up.
- Tune enum: INTRO/VERSE/OUTRO/HOOK/CHORUS/BRIDGE.

## Связи
- [SYS-03](../systems/SYS-03-odeum.md), [SYS-05](../systems/SYS-05-attack-shadow.md)
- [CONTENT-02](CONTENT-02-card-echo-shadow.md), [CONTENT-03](CONTENT-03-house-room-scenario.md)

## TODO / открытые вопросы
- Структура Hymn↔Canto графа — уточнить поля.
