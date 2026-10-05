# CONTENT-06 Mission / Gang / Idea / Opportunity / Intention / Ambition / Attempt
**Статус:** черновик
**Источники:** [entities/isle/mission/](../../entities/isle/mission/)

## Назначение
Схема миссионного графа (не значения opportunity `.tres`).

## Ключевые сущности / шаги
- Aggregates: `MissionData`, `GangData`, `BankData`, `MethodData`.
- Idea graph: `IdeaData`, `IntentionData` (Resource), `OpportunityData` (Resource).
- Ambition: `AmbitionData`, `PotentialData` (+ UI class `Potenital` typo).
- Attempt: `AttemptData`, `PlanData`, `ImpulseData`.

## Связи
- [SYS-08](../systems/SYS-08-mission-gang-loot.md), [FLOW-08](../flows/FLOW-08-mission-attempt-loot.md)
- [CONTENT-07](CONTENT-07-loot-shard-spark.md), [TECH-03](../tech/TECH-03-data-pattern.md)

## TODO / открытые вопросы
- Поля OpportunityData/IntentionData — из Resource-файлов.
