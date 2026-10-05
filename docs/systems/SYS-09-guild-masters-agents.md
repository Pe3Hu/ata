# SYS-09 Guild / masters / agents
**Статус:** черновик
**Источники:** [entities/continent/guild/](../../entities/continent/guild/), [global/Mother.gd](../../global/Mother.gd), [global/Bozo.gd](../../global/Bozo.gd) (`enum Master`)

## Назначение
Гильдия на континенте: смена master UI, задачи, агенты (squad/calendar/workload), tribute/quotum, circuit scout/lightkeeper.

## Ключевые сущности / шаги
- `Mother.guild: GuildData`; сигнал `master_changed` → `Guild` меняет сцену master.
- `MasterData.task_changed` → UI `Agent` перепривязывается.
- Masters: Archaeologist, Architect, Barkeeper, Blacksmith, Demon (stub), Lightkeeper, Miner, Musician, Scout, Tailor.
- Agent: `Squad`/`Member`, `Calendar`, `Hourglass`, `Workload`/`Overtime`, `Task`.
- Tribute/`Quotum`/`Spoil` (Spoil stub); quotum связан с pie.
- Circuit: `ScoutCircuit`, `LightkeeperCircuit` — линии между shelters.

## Связи
- [SYS-06](SYS-06-kernel-economy.md), [SYS-10](SYS-10-mainland-navigation.md), [SYS-11](SYS-11-dice.md)
- [CONTENT-09](../content/CONTENT-09-guild-types.md)
- [FLOW-07](../flows/FLOW-07-guild-task-agent.md), [FLOW-06](../flows/FLOW-06-mainland-travel.md)
- [TECH-02](../tech/TECH-02-mother-hub.md)

## TODO / открытые вопросы
- GROWTH/RECRUITMENT фазы vs barkeeper recruit — связь с Arbitrator не найдена.
- Demon/Spoil — stub-наследники без логики.
