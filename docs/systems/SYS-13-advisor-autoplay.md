# SYS-13 Advisor / autoplay
**Статус:** черновик
**Источники:** [global/advisor/](../../global/advisor/), [global/arbitrator/Arbitrator.gd](../../global/arbitrator/Arbitrator.gd), [global/Gear.gd](../../global/Gear.gd)

## Назначение
Автовыбор действий для фаз DECISION и FUSION; включается через `Gear.is_auto_play` и цепочку `last_action`.

## Ключевые сущности / шаги
- `Advisor.phase_to_choice`: DECISION→`ChoiceDecision`, FUSION→`ChoiceFusion`.
- `ChoiceDecision.next_action`: activate bedroom cards до kitchen limit, иначе `voice_canto` + `ActionAttackShadow`, иначе exit phase.
- `ChoiceFusion`: `simulate_anvil_choice()`.
- База `Choice` (`extends Resource`): tween list, exit → `current_phase.exit_phase()`.

## Связи
- [SYS-01](SYS-01-round-phases.md), [SYS-02](SYS-02-house-cards.md), [SYS-04](SYS-04-arsenal-fusion.md), [SYS-05](SYS-05-attack-shadow.md)
- [FLOW-02](../flows/FLOW-02-decision-attack.md), [FLOW-03](../flows/FLOW-03-discard-fusion.md)
- [TECH-04](../tech/TECH-04-phase-choice-action.md), [TECH-07](../tech/TECH-07-gear-animation.md)

## TODO / открытые вопросы
- `ChoiceFusion` не определяет `next_action`.
- Зависимость от `Arbitrator.faction` — поле отсутствует.
