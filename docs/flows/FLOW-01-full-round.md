# FLOW-01 Полный игровой раунд
**Статус:** черновик
**Источники:** [global/arbitrator/Arbitrator.gd](../../global/arbitrator/Arbitrator.gd), [global/arbitrator/phase/](../../global/arbitrator/phase/)

## Назначение
Сквозной сценарий одного раунда: пять фаз подряд, затем инкремент `current_round` или останов по pause/gameover.

## Ключевые сущности / шаги
1. `start_new_round()` — round++, index=0.
2. DRAW — refill house, `odeum.init_scenarios`, `house.draw_phase`.
3. DECISION — Advisor/игрок, move cards / attack shadow.
4. DISCARD — kitchen→forge, clear kitchen, `discard_phase`.
5. FUSION — anvils, choice, `phase_finished`.
6. PUNISHMENT — `punishment_phase` при parlor stamps → долги.
7. Конец массива phases → снова шаг 1.

## Связи
- [SYS-01](../systems/SYS-01-round-phases.md), [SYS-02](../systems/SYS-02-house-cards.md), [SYS-04](../systems/SYS-04-arsenal-fusion.md), [SYS-05](../systems/SYS-05-attack-shadow.md), [SYS-13](../systems/SYS-13-advisor-autoplay.md)
- [FLOW-02](FLOW-02-decision-attack.md), [FLOW-03](FLOW-03-discard-fusion.md), [FLOW-04](FLOW-04-punishment-debts.md)
- [TECH-04](../tech/TECH-04-phase-choice-action.md)

## TODO / открытые вопросы
- Кто стартует первый раунд — TODO.
- Влияние `is_gameover=true` по умолчанию в Arbitrator.
