# SYS-02 House / карты / комнаты
**Статус:** черновик
**Источники:** [entities/isle/house/house.gd](../../entities/isle/house/house.gd), [entities/isle/house/house_data.gd](../../entities/isle/house/house_data.gd), [entities/isle/house/room/](../../entities/isle/house/room/), [entities/isle/house/card/](../../entities/isle/house/card/), [entities/isle/house/scenario_data.gd](../../entities/isle/house/scenario_data.gd), [global/Mother.gd](../../global/Mother.gd)

## Назначение
Игровое поле «дома» на острове: комнаты с Echo/Shadow, сигналы фаз draw/discard/punishment, refill attic→parlor/bedroom.

## Ключевые сущности / шаги
- `Mother.house: HouseData` создаётся в `Mother._ready`.
- Комнаты: `attic`, `parlor`, `bedroom`, `kitchen`, `cellar`; кольца `fol`/`ere` ([house_data.gd](../../entities/isle/house/house_data.gd)).
- Сигналы: `draw_phase`, `discard_phase`, `punishment_phase`, `advisor_card_activation`.
- Refill: `refill_parlor()`, `direct_refill_bedroom()` — лимиты `Catalog.GYRE_*`.
- UI: `House` / `Room` / `Card`; данные `EchoData`, `ShadowData`, `StakeData`, `ScenarioData`.
- Перемещение: `ActionMoveCard` ([global/arbitrator/action/action_move_card.gd](../../global/arbitrator/action/action_move_card.gd)).

## Связи
- [SYS-01](SYS-01-round-phases.md), [SYS-03](SYS-03-odeum.md), [SYS-04](SYS-04-arsenal-fusion.md), [SYS-05](SYS-05-attack-shadow.md), [SYS-13](SYS-13-advisor-autoplay.md)
- [CONTENT-02](../content/CONTENT-02-card-echo-shadow.md), [CONTENT-03](../content/CONTENT-03-house-room-scenario.md)
- [FLOW-01](../flows/FLOW-01-full-round.md), [FLOW-02](../flows/FLOW-02-decision-attack.md)

## TODO / открытые вопросы
- Полный список input-хендлеров карт — не разобран построчно.
- Граничные случаи attic.ere / shuffle — TODO.
