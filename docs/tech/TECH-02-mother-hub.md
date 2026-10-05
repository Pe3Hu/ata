# TECH-02 Mother data hub
**Статус:** черновик
**Источники:** [global/Mother.gd](../../global/Mother.gd)

## Назначение
Autoload-хранилище сессионных `*Data`; точка init мира данных.

## Ключевые сущности / шаги
- Static vars: `kernel`, `house`, `odeum`, `arsenal`, `mission`, `welkin`, `mainland`, `guild`, `clock`, `overseer`.
- `_ready` создаёт экземпляры и коннектит `clock.time_changed` → `clock_updated`.
- Сигналы: `declare_gameover`, `clock_updated`.
- `_on_declare_gameover` пишет `Arbitrator.s_gameover` (поле в Arbitrator отсутствует — баг/долг).

## Связи
- [TECH-01](TECH-01-autoloads.md), [TECH-03](TECH-03-data-pattern.md), [TECH-05](TECH-05-signals-bus.md)
- [SYS-02](../systems/SYS-02-house-cards.md), [SYS-06](../systems/SYS-06-kernel-economy.md), [SYS-09](../systems/SYS-09-guild-masters-agents.md), [SYS-10](../systems/SYS-10-mainland-navigation.md)

## TODO / открытые вопросы
- Исправить `s_gameover` vs `is_gameover`.
- Нет reset/new-run API — TODO: не найдено.
