# SYS-01 Раунд и фазы (Arbitrator)
**Статус:** черновик
**Источники:** [global/arbitrator/Arbitrator.gd](../../global/arbitrator/Arbitrator.gd), [global/arbitrator/phase/](../../global/arbitrator/phase/), [global/Bozo.gd](../../global/Bozo.gd) (`enum Phase`), [global/Gear.gd](../../global/Gear.gd), [project.godot](../../project.godot) (autoload `Arbitrator`)

## Назначение
Контроллер игрового раунда: последовательность фаз, переход по `phase_completed`, пауза/gameover-гейты, очередь tween-анимаций. Связывает фазы с Advisor при auto-play.

## Ключевые сущности / шаги
- `Arbitrator.phases` в `_ready`: `PhaseDraw` → `PhaseDecision` → `PhaseDiscard` → `PhaseFusion` → `PhasePunishment`.
- `start_new_round()` → `start_next_phase()`; emit `phase_changed`; `enter_phase()`.
- No-op если `Gear.is_pause` или `is_gameover`.
- `last_action` setter при `Gear.is_auto_play` и `null` → `Advisor.get_choice().next_action()`.
- `skip_phase()` эмитит `phase_completed`.
- `Bozo.Phase.GROWTH` / `RECRUITMENT` в enum есть, в массив phases не входят.

## Связи
- [FLOW-01](../flows/FLOW-01-full-round.md), [FLOW-02](../flows/FLOW-02-decision-attack.md), [FLOW-03](../flows/FLOW-03-discard-fusion.md), [FLOW-04](../flows/FLOW-04-punishment-debts.md)
- [SYS-02](SYS-02-house-cards.md), [SYS-04](SYS-04-arsenal-fusion.md), [SYS-05](SYS-05-attack-shadow.md), [SYS-13](SYS-13-advisor-autoplay.md)
- [TECH-01](../tech/TECH-01-autoloads.md), [TECH-04](../tech/TECH-04-phase-choice-action.md), [TECH-07](../tech/TECH-07-gear-animation.md)

## TODO / открытые вопросы
- `Arbitrator.faction` используется фазами/choices — определения в `Arbitrator.gd` нет.
- `Mother` пишет `Arbitrator.s_gameover`, в Arbitrator — `is_gameover`.
- Точка первого вызова `start_new_round()` из UI — TODO: не найдено в этом проходе.
