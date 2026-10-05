# FLOW-03 Discard → Fusion → restore house
**Статус:** черновик
**Источники:** [global/arbitrator/phase/phase_discard.gd](../../global/arbitrator/phase/phase_discard.gd), [global/arbitrator/phase/phase_fusion.gd](../../global/arbitrator/phase/phase_fusion.gd), [entities/isle/arsenal/arsenal_data.gd](../../entities/isle/arsenal/arsenal_data.gd)

## Назначение
Перенос kitchen echos на forge, фаза fusion на anvils, завершение с восстановлением комнат/odeum.

## Ключевые сущности / шаги
1. DISCARD: `update_forge_echos`, clear kitchen, emit `discard_phase`.
2. FUSION: `init_anvils`, optional Advisor `simulate_anvil_choice`.
3. Exit fusion → `ArsenalData.phase_finished` → UI/house restore (слушатели arsenal).

## Связи
- [SYS-04](../systems/SYS-04-arsenal-fusion.md), [SYS-02](../systems/SYS-02-house-cards.md), [SYS-13](../systems/SYS-13-advisor-autoplay.md)
- [FLOW-01](FLOW-01-full-round.md)
- [CONTENT-05](../content/CONTENT-05-arsenal-anvil.md)

## TODO / открытые вопросы
- Зависимость от `Arbitrator.faction.forge` — TODO определение.
