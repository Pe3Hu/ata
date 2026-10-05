# CONTENT-02 Card / Echo / Shadow / Stake / Soul
**Статус:** черновик
**Источники:** [entities/isle/house/card/](../../entities/isle/house/card/), [entities/isle/house/card/echo/echo_data.gd](../../entities/isle/house/card/echo/echo_data.gd), [entities/isle/house/card/shadow/shadow_data.gd](../../entities/isle/house/card/shadow/shadow_data.gd), [entities/isle/house/card/echo/stake/stake_data.gd](../../entities/isle/house/card/echo/stake/stake_data.gd)

## Назначение
Схема карточных сущностей дома: визуал Card, данные Echo/Shadow/Stake/Soul.

## Ключевые сущности / шаги
- UI: `Card`, `Echo`, `Shadow`, `Stake`.
- Data (в основном RefCounted): `EchoData` (`is_locked_changed`), `ShadowData` (`shade_changed`, `is_perished`), `StakeData` (`canto_changed`, `is_voiced_changed`).
- `SoulData` — используется Helper.reincarnation / member preview (см. MemberData).
- Связь с `RoomData.echos` и `Bozo.Room` / `Bozo.Stake`.

## Связи
- [SYS-02](../systems/SYS-02-house-cards.md), [SYS-05](../systems/SYS-05-attack-shadow.md), [SYS-03](../systems/SYS-03-odeum.md)
- [CONTENT-03](CONTENT-03-house-room-scenario.md), [CONTENT-04](CONTENT-04-odeum-hymn-canto.md)

## TODO / открытые вопросы
- Полный список полей EchoData/ShadowData — выписать во втором проходе.
- Где объявлен SoulData файл — подтвердить путь.
