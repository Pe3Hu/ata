# FLOW-02 Decision → voice canto → attack shadow
**Статус:** черновик
**Источники:** [global/arbitrator/phase/phase_decision.gd](../../global/arbitrator/phase/phase_decision.gd), [global/advisor/choice/choice_decision.gd](../../global/advisor/choice/choice_decision.gd), [global/arbitrator/action/action_attack_shadow.gd](../../global/arbitrator/action/action_attack_shadow.gd)

## Назначение
Сценарий фазы DECISION: активация карт bedroom→kitchen, выбор canto, удар по Shadow.

## Ключевые сущности / шаги
1. `PhaseDecision.enter` → `Advisor.apply_choice()` (если auto) / ожидание игрока.
2. Пока bedroom stamps и kitchen < limit → `advisor_card_activation` / `ActionMoveCard`.
3. Иначе `voice_canto()` → выбор canto + shadow.
4. `ActionAttackShadow.execute()` — voice, уменьшить shade, perfect flag.
5. Возможный хук stepladder после анимации (см. PhaseDecision).

## Связи
- [SYS-02](../systems/SYS-02-house-cards.md), [SYS-03](../systems/SYS-03-odeum.md), [SYS-05](../systems/SYS-05-attack-shadow.md), [SYS-07](../systems/SYS-07-stepladder.md), [SYS-13](../systems/SYS-13-advisor-autoplay.md)
- [FLOW-01](FLOW-01-full-round.md)

## TODO / открытые вопросы
- Ручной (не-advisor) путь игрока — детали UI TODO.
