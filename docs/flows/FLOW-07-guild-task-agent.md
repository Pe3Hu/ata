# FLOW-07 Guild: master → task → agent work
**Статус:** черновик
**Источники:** [entities/continent/guild/guild.gd](../../entities/continent/guild/guild.gd), [entities/continent/guild/guild_data.gd](../../entities/continent/guild/guild_data.gd), [entities/continent/guild/agent/](../../entities/continent/guild/agent/), [entities/continent/guild/master/](../../entities/continent/guild/master/), [entities/continent/guild/tribute/](../../entities/continent/guild/tribute/)

## Назначение
Смена мастера, привязка task/agent, прогресс workload/calendar, quotum↔pie.

## Ключевые сущности / шаги
1. `GuildData.master_changed` → swap master scene.
2. `MasterData.task_changed` → Agent UI на текущего agent задачи.
3. Calendar/hourglass слушают clock (`hour_passed` / Mother.overseer).
4. Workload/overtime progress; intro-dice averages на agent.
5. Tribute quotum_changed → pie.minus_quotum.

## Связи
- [SYS-09](../systems/SYS-09-guild-masters-agents.md), [SYS-06](../systems/SYS-06-kernel-economy.md), [SYS-11](../systems/SYS-11-dice.md)
- [CONTENT-09](../content/CONTENT-09-guild-types.md)
- [FLOW-06](FLOW-06-mainland-travel.md)

## TODO / открытые вопросы
- Завершение task (`TaskData.is_finished`) → что дальше — TODO детали.
