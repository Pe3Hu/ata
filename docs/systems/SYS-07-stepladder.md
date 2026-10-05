# SYS-07 Stepladder / pressure rolls
**Статус:** черновик
**Источники:** [entities/isle/ladder/](../../entities/isle/ladder/), [entities/isle/kernel/kernel_data.gd](../../entities/isle/kernel/kernel_data.gd), [global/Helper.gd](../../global/Helper.gd), [global/Catalog.gd](../../global/Catalog.gd)

## Назначение
Лестница давления: stairs/girders/FakeDice; реагирует на volume/pressure maelstrom и участвует в цепочках после decision/punishment.

## Ключевые сущности / шаги
- `StepladderData` в `KernelData.stepladder`; сигналы `volume_changed`, `pressure_changed`.
- Классы: `Stepladder`, `Stair`, `Girder`, `FakeDice`, `LadderData`.
- `Helper.ladder: LadderData`.
- Константы размеров — Catalog.

## Связи
- [SYS-05](SYS-05-attack-shadow.md), [SYS-06](SYS-06-kernel-economy.md), [SYS-11](SYS-11-dice.md)
- [CONTENT-01](../content/CONTENT-01-dice-hierarchy.md), [CONTENT-08](../content/CONTENT-08-kernel-types.md)
- [FLOW-02](../flows/FLOW-02-decision-attack.md), [FLOW-04](../flows/FLOW-04-punishment-debts.md)

## TODO / открытые вопросы
- Алгоритм FakeDice vs PressureDice — второй проход.
- Файл данных girder назван `grider_data.gd` (опечатка пути).
