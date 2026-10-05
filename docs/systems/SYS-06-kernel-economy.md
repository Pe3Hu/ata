# SYS-06 Kernel / экономика сессии
**Статус:** черновик
**Источники:** [entities/isle/kernel/](../../entities/isle/kernel/), [global/Mother.gd](../../global/Mother.gd), [global/Catalog.gd](../../global/Catalog.gd)

## Назначение
Сессионная экономика/давление острова: pie, usurer/debts, maelstrom, clock/overseer. Агрегат — `KernelData`.

## Ключевые сущности / шаги
- `Mother.kernel`, `Mother.clock`, `Mother.overseer`.
- `KernelData`: `usurer`, `pie`, `maelstrom`, `stepladder` ([kernel_data.gd](../../entities/isle/kernel/kernel_data.gd)).
- `UsurerData`: `update_debts`, `delcare_bankruptcy` (опечатка в сигнале).
- `Pie`/`Slice` + quotum гильдии (`minus_quotum`).
- `ClockData`: `time_changed`, `hour_passed` → `Mother.clock_updated`.

## Связи
- [SYS-07](SYS-07-stepladder.md), [SYS-09](SYS-09-guild-masters-agents.md)
- [CONTENT-08](../content/CONTENT-08-kernel-types.md)
- [FLOW-04](../flows/FLOW-04-punishment-debts.md), [FLOW-07](../flows/FLOW-07-guild-task-agent.md)
- [TECH-02](../tech/TECH-02-mother-hub.md)

## TODO / открытые вопросы
- Роль `kernel/lantern` — TODO: не разобрана.
- Полный путь bankruptcy → gameover — уточнить подписчиков.
