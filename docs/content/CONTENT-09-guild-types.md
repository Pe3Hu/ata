# CONTENT-09 Guild / Master / Agent / Task / Squad / Tribute
**Статус:** черновик
**Источники:** [entities/continent/guild/](../../entities/continent/guild/), [global/Bozo.gd](../../global/Bozo.gd) (`enum Master`, `Rank`)

## Назначение
Схема гильдейских типов и подтипов master-задач.

## Ключевые сущности / шаги
- Core: `GuildData`, `MasterData`, `AgentData`, `TaskData`, `SquadData`, `MemberData`.
- Work: `WorkloadData`, `Calendar`, `Hourglass`, `Overtime`.
- Tribute: `TributeData`, `QuotumData`, `SpoilData` (stub).
- Master subtypes (data): Cave/Lode/Vein, Attire, Instrument/Razor, Obstacle, Altar/Sculpture, Recruit/Silhouette/Veteran, Spotlight/Firework, Demon (stub).

## Связи
- [SYS-09](../systems/SYS-09-guild-masters-agents.md), [FLOW-07](../flows/FLOW-07-guild-task-agent.md)
- [CONTENT-10](CONTENT-10-mainland-types.md)

## TODO / открытые вопросы
- Единая таблица полей TaskData по master-типу — собрать позже.
