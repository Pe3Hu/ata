# TECH-05 Signals bus
**Статус:** черновик
**Источники:** grep `^signal` по `*.gd`

## Назначение
Карта межсистемных сигналов (не полный перечень локальных UI-сигналов).

## Ключевые сущности / шаги
- Arbitrator: `phase_changed`
- Mother: `declare_gameover`, `clock_updated`
- HouseData: draw/discard/punishment/advisor_card_activation
- ArsenalData: fusion_phase / phase_finished
- GuildData: master_changed; MasterData: task_changed
- ClockData: time_changed / hour_passed
- Mainland: Route/Footprint/Beam/Haze/Shrine signals
- Usurer: update_debts / delcare_bankruptcy
- DragDrop: dragged(from,to)

## Связи
- [SYS-01](../systems/SYS-01-round-phases.md), [SYS-02](../systems/SYS-02-house-cards.md), [SYS-09](../systems/SYS-09-guild-masters-agents.md), [SYS-10](../systems/SYS-10-mainland-navigation.md)
- [TECH-02](TECH-02-mother-hub.md), [TECH-04](TECH-04-phase-choice-action.md)

## TODO / открытые вопросы
- Диаграмма подписок (кто connect) — второй проход.
