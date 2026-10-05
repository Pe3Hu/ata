# FLOW-04 Punishment → долги
**Статус:** черновик
**Источники:** [global/arbitrator/phase/phase_punishment.gd](../../global/arbitrator/phase/phase_punishment.gd), [entities/isle/house/house_data.gd](../../entities/isle/house/house_data.gd), [entities/isle/kernel/usurer/usurer_data.gd](../../entities/isle/kernel/usurer/usurer_data.gd)

## Назначение
Фаза punishment: при parlor stamps эмит `punishment_phase`, броски/штрафы ведут к долгам usurer.

## Ключевые сущности / шаги
1. `PhasePunishment.enter` — если parlor stamps → `house.punishment_phase`.
2. Card/punishment dice логика начисляет debt (Card → usurer).
3. `UsurerData.update_debts` / `delcare_bankruptcy`.
4. Exit phase → `_on_punishment_phase_end`.

## Связи
- [SYS-01](../systems/SYS-01-round-phases.md), [SYS-02](../systems/SYS-02-house-cards.md), [SYS-06](../systems/SYS-06-kernel-economy.md), [SYS-07](../systems/SYS-07-stepladder.md), [SYS-11](../systems/SYS-11-dice.md)
- [FLOW-01](FLOW-01-full-round.md)
- [CONTENT-08](../content/CONTENT-08-kernel-types.md)

## TODO / открытые вопросы
- Точная формула fine/debt по matter — второй проход по Card/Usurer.
