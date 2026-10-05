# SYS-04 Arsenal / fusion (anvil)
**Статус:** черновик
**Источники:** [entities/isle/arsenal/](../../entities/isle/arsenal/), [global/arbitrator/phase/phase_fusion.gd](../../global/arbitrator/phase/phase_fusion.gd), [global/arbitrator/phase/phase_discard.gd](../../global/arbitrator/phase/phase_discard.gd), [global/advisor/choice/choice_fusion.gd](../../global/advisor/choice/choice_fusion.gd), [global/Catalog.gd](../../global/Catalog.gd)

## Назначение
Фаза fusion: echo из kitchen → forge/anvils, выбор раскладки (игрок/Advisor), затем `phase_finished` и восстановление house.

## Ключевые сущности / шаги
- `Mother.arsenal: ArsenalData`; сигналы `fusion_phase`, `phase_finished`.
- Discard копирует kitchen echos на forge (через `Arbitrator.faction.*` — поле faction TODO).
- `PhaseFusion`: `forge.init_anvils()`; Advisor если anvils есть.
- `ChoiceFusion` → `forge.simulate_anvil_choice()`.
- UI: `Arsenal`, `Anvil` + `AnvilData`.

## Связи
- [SYS-01](SYS-01-round-phases.md), [SYS-02](SYS-02-house-cards.md), [SYS-13](SYS-13-advisor-autoplay.md)
- [CONTENT-05](../content/CONTENT-05-arsenal-anvil.md)
- [FLOW-03](../flows/FLOW-03-discard-fusion.md)
- [TECH-04](../tech/TECH-04-phase-choice-action.md)

## TODO / открытые вопросы
- Где объявлен `forge` / `faction` — TODO: не найдено в Arbitrator.
- Auto-play FUSION: `next_action` есть только у `ChoiceDecision`.
