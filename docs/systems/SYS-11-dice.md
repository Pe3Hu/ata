# SYS-11 Dice
**Статус:** черновик
**Источники:** [entities/dice/datas/](../../entities/dice/datas/), [global/Digest.gd](../../global/Digest.gd)

## Назначение
Иерархия кубиков как Godot Resource: общий `roll_result()`, типизированные intro/matter/pressure/punishment/verse; Digest индексирует intro `.tres` при init.

## Ключевые сущности / шаги
- `DiceData` (`extends Resource`): `@export values`, `roll_result()` = `values.pick_random()`.
- Подтипы: `IntroDiceData`, `MatterDiceData`, `PressureDiceData`, `PunishmentDiceData`, `VerseDiceData`.
- `Digest.init_intros()` грузит `res://entities/dice/datas/intro/%d_%d.tres`.
- Потребители: agent, stepladder/FakeDice, card punishment — см. связанные SYS.

## Связи
- [SYS-07](SYS-07-stepladder.md), [SYS-09](SYS-09-guild-masters-agents.md), [SYS-02](SYS-02-house-cards.md)
- [CONTENT-01](../content/CONTENT-01-dice-hierarchy.md)
- [TECH-03](../tech/TECH-03-data-pattern.md), [TECH-01](../tech/TECH-01-autoloads.md)

## TODO / открытые вопросы
- Полный список call-sites `roll_result()` — расширить во втором проходе.
