# CONTENT-05 Arsenal / Anvil
**Статус:** черновик
**Источники:** [entities/isle/arsenal/arsenal_data.gd](../../entities/isle/arsenal/arsenal_data.gd), [entities/isle/arsenal/anvil/anvil_data.gd](../../entities/isle/arsenal/anvil/anvil_data.gd), [global/Catalog.gd](../../global/Catalog.gd)

## Назначение
Схема forge/anvil для фазы fusion.

## Ключевые сущности / шаги
- `ArsenalData` / `AnvilData` (RefCounted-паттерн).
- Сигналы arsenal: `fusion_phase`, `phase_finished`.
- Константы fusion mark lengths в Catalog.

## Связи
- [SYS-04](../systems/SYS-04-arsenal-fusion.md), [FLOW-03](../flows/FLOW-03-discard-fusion.md)
- [CONTENT-02](CONTENT-02-card-echo-shadow.md)

## TODO / открытые вопросы
- Поля AnvilData (marks, echos) — выписать из файла.
