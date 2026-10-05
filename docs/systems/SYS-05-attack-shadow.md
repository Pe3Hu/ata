# SYS-05 Attack Shadow (бой-лайт)
**Статус:** черновик
**Источники:** [global/arbitrator/action/action_attack_shadow.gd](../../global/arbitrator/action/action_attack_shadow.gd), [global/advisor/choice/choice_decision.gd](../../global/advisor/choice/choice_decision.gd), [entities/isle/house/card/shadow/shadow_data.gd](../../entities/isle/house/card/shadow/shadow_data.gd), [entities/isle/odeum/canto/canto_data.gd](../../entities/isle/odeum/canto/canto_data.gd)

## Назначение
Единственный найденный «боевой» экшен: озвученный canto уменьшает `shadow.current_shade` на `pulse_value`; perfect при нулевом остатке.

## Ключевые сущности / шаги
- `ActionAttackShadow` (`shadow`, `is_advisor`, `is_perfect`) → `execute()` voice + урон.
- `ChoiceDecision.voice_canto()` выбирает canto и Shadow, ставит action.
- `ShadowData`: `shade_changed`, `is_perished`.
- Отдельного combat/HP-модуля нет.

## Связи
- [SYS-02](SYS-02-house-cards.md), [SYS-03](SYS-03-odeum.md), [SYS-07](SYS-07-stepladder.md), [SYS-13](SYS-13-advisor-autoplay.md)
- [FLOW-02](../flows/FLOW-02-decision-attack.md)
- [CONTENT-02](../content/CONTENT-02-card-echo-shadow.md), [CONTENT-04](../content/CONTENT-04-odeum-hymn-canto.md)
- [TECH-04](../tech/TECH-04-phase-choice-action.md)

## TODO / открытые вопросы
- Таблица PERFECT/OVERKILL/MAX — детализировать из `ChoiceDecision`.
- Цепочка stepladder после attack — уточнить в `PhaseDecision`.
