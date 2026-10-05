# TECH-04 Phase / Choice / Action pipeline
**Статус:** черновик
**Источники:** [global/arbitrator/](../../global/arbitrator/), [global/advisor/](../../global/advisor/)

## Назначение
Техпайплайн раунда: Phase (Resource) исполняет ActionData (RefCounted); Advisor подставляет Choice (Resource).

## Ключевые сущности / шаги
- `Phase`: `enter/exit`, `try_execute_action`, tween drain → `phase_completed`.
- `ActionData.execute()` ставит `Arbitrator.last_action`; `animation_left`→0 очищает.
- Реализации: `ActionMoveCard`, `ActionAttackShadow`.
- `Choice`: enter/exit, анимации; Decision/Fusion subclasses.

## Связи
- [SYS-01](../systems/SYS-01-round-phases.md), [SYS-13](../systems/SYS-13-advisor-autoplay.md), [SYS-05](../systems/SYS-05-attack-shadow.md)
- [TECH-05](TECH-05-signals-bus.md), [TECH-07](TECH-07-gear-animation.md)
- [FLOW-01](../flows/FLOW-01-full-round.md)

## TODO / открытые вопросы
- `ActionMoveCard` вызов `room_data.echos(...)` выглядит невалидно для Array — проверить.
- `Arbitrator.faction` dependency.
