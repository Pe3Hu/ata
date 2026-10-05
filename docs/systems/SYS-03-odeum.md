# SYS-03 Odeum / гимны / canto
**Статус:** черновик
**Источники:** [entities/isle/odeum/](../../entities/isle/odeum/), [global/arbitrator/phase/phase_draw.gd](../../global/arbitrator/phase/phase_draw.gd), [global/Mother.gd](../../global/Mother.gd)

## Назначение
Сценарно-музыкальный слой острова: Hymn/Canto/Tune/Pulse строятся из сценариев bedroom/kitchen и участвуют в voice/attack.

## Ключевые сущности / шаги
- `Mother.odeum: OdeumData`.
- Сигналы `bedroom_scenario_changed`, `kitchen_scenario_changed` ([odeum_data.gd](../../entities/isle/odeum/odeum_data.gd)).
- `PhaseDraw` → `Mother.odeum.init_scenarios()`.
- Иерархия: Odeum → Hymn → Canto → Tune / Pulse.
- `CantoData`: `pulse_changed`, `is_perfect_changed`, `is_selected_changed`, `voice_up`.
- `StakeData` связан с canto (`canto_changed`, `is_voiced_changed`).

## Связи
- [SYS-02](SYS-02-house-cards.md), [SYS-05](SYS-05-attack-shadow.md), [SYS-13](SYS-13-advisor-autoplay.md)
- [CONTENT-04](../content/CONTENT-04-odeum-hymn-canto.md)
- [FLOW-02](../flows/FLOW-02-decision-attack.md)

## TODO / открытые вопросы
- Формула `pulse_value` / perfect — детализировать во втором проходе.
- `shift_canto.gd` — stub на `CustomButton`.
