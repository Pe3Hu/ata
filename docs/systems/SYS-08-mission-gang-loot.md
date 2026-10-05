# SYS-08 Mission / gang / bank / loot
**Статус:** черновик
**Источники:** [entities/isle/mission/](../../entities/isle/mission/), [entities/isle/loot/](../../entities/isle/loot/), [global/Mother.gd](../../global/Mother.gd)

## Назначение
Миссионный контур острова: bank methods, gang ideas/ambition/attempt, отображение loot (shard/spark). Классического inventory API нет.

## Ключевые сущности / шаги
- `Mother.mission: MissionData`.
- UI `Mission` связывает `Bank`/`Method`, `Gang`/`Idea`/`Intention`/`Opportunity`, `Ambition`/`Potential`, `Attempt`/`Plan`/`Impulse`.
- Сигналы идей: `active_changed`, `bond_changed`, `attempt_implemented`; attempt: `idea_chaged` (опечатка).
- `Loot` инстанцирует `Shard`/`Spark` из `LootData`.
- Opportunity/Intention — `extends Resource` с `.tres` в `opportunity/`.

## Связи
- [SYS-06](SYS-06-kernel-economy.md), [SYS-11](SYS-11-dice.md)
- [CONTENT-06](../content/CONTENT-06-mission-gang.md), [CONTENT-07](../content/CONTENT-07-loot-shard-spark.md)
- [FLOW-08](../flows/FLOW-08-mission-attempt-loot.md)

## TODO / открытые вопросы
- Когда mission UI открывается относительно раунда Arbitrator — TODO: не найдено явной фазовой привязки.
- Класс `Potenital` — опечатка class_name в `potential.gd`.
