# CONTENT-03 House / Room / Scenario
**Статус:** черновик
**Источники:** [entities/isle/house/house_data.gd](../../entities/isle/house/house_data.gd), [entities/isle/house/room/room_data.gd](../../entities/isle/house/room/room_data.gd), [entities/isle/house/scenario_data.gd](../../entities/isle/house/scenario_data.gd), [global/Bozo.gd](../../global/Bozo.gd) (`enum Room`)

## Назначение
Схема комнат дома и сценариев, влияющих на odeum.

## Ключевые сущности / шаги
- `HouseData` владеет 5 `RoomData` + `type_to_room`.
- `RoomData`: echos, fol/ere соседи, сигнал `cards_reseted`.
- `ScenarioData` extends `Resource` — схема сценария комнаты.
- Enum комнат: ATTIC/PARLOR/BEDROOM/KITCHEN/CELLAR.

## Связи
- [SYS-02](../systems/SYS-02-house-cards.md), [SYS-03](../systems/SYS-03-odeum.md)
- [CONTENT-02](CONTENT-02-card-echo-shadow.md), [CONTENT-04](CONTENT-04-odeum-hymn-canto.md)
- [CONTENT-12](CONTENT-12-cottage-chamber.md) (параллельная схема cottage)

## TODO / открытые вопросы
- Поля ScenarioData — детализировать.
