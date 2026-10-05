# TECH-07 Gear / animation timing
**Статус:** черновик
**Источники:** [global/Gear.gd](../../global/Gear.gd), [global/arbitrator/Arbitrator.gd](../../global/arbitrator/Arbitrator.gd), [global/advisor/Advisor.gd](../../global/advisor/Advisor.gd)

## Назначение
Глобальные флаги темпа/паузы/autoplay и таблицы длительностей анимаций.

## Ключевые сущности / шаги
- Vars: `tempo`, `is_auto_play`, `is_pause`.
- Const arrays: rolls/appears/activates/jalousies/expands/cants/flips/debts/sorts/bonds/dissolves/pressures/workloads/hourglass.
- `Arbitrator.queue_an_animation` / `Advisor.queue_an_animation` кладут tween в текущую phase/choice.

## Связи
- [SYS-01](../systems/SYS-01-round-phases.md), [SYS-13](../systems/SYS-13-advisor-autoplay.md)
- [TECH-04](TECH-04-phase-choice-action.md)

## TODO / открытые вопросы
- Кто меняет `tempo`/`is_pause` из UI — TODO call-sites.
