# SYS-12 Welkin / asterisms
**Статус:** черновик
**Источники:** [entities/isle/welkin/](../../entities/isle/welkin/), [global/Mother.gd](../../global/Mother.gd)

## Назначение
UI «небосвода»: спавн asterism/star из `Mother.welkin`.

## Ключевые сущности / шаги
- `Mother.welkin: WelkinData` создаётся первым в `Mother._ready`.
- UI `Welkin` / `Asterism`; данные `AsterismData`, `StarData` (`current_changed`).

## Связи
- [SYS-02](SYS-02-house-cards.md), [SYS-09](SYS-09-guild-masters-agents.md)
- [TECH-02](../tech/TECH-02-mother-hub.md)

## TODO / открытые вопросы
- Win-condition / прогресс welkin — TODO: не найдено.
- Связь Constellation (architect) ↔ Asterism — TODO.
