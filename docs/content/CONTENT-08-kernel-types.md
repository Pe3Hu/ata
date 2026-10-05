# CONTENT-08 Kernel: Pie / Debt / Maelstrom / Clock
**Статус:** черновик
**Источники:** [entities/isle/kernel/](../../entities/isle/kernel/)

## Назначение
Схема session-economy типов ядра.

## Ключевые сущности / шаги
- `KernelData` → usurer/pie/maelstrom/stepladder.
- Pie: `PieData`, `SliceData` (`amount_changed`).
- Usurer: `UsurerData`, `DebtData`, `FineData`.
- Maelstrom: `MaelstromData`, `EddyData`, `FluxData`, `PressureData`, UI `Volume`.
- Time: `ClockData`, `OverseerData`.

## Связи
- [SYS-06](../systems/SYS-06-kernel-economy.md), [SYS-07](../systems/SYS-07-stepladder.md)
- [FLOW-04](../flows/FLOW-04-punishment-debts.md)
- [CONTENT-01](CONTENT-01-dice-hierarchy.md)

## TODO / открытые вопросы
- Lantern types — TODO.
