# FLOW-08 Mission idea → attempt → loot
**Статус:** черновик
**Источники:** [entities/isle/mission/](../../entities/isle/mission/), [entities/isle/loot/](../../entities/isle/loot/)

## Назначение
Сценарий миссии: активация idea/bond, ambition/potential, attempt, показ loot shards/sparks.

## Ключевые сущности / шаги
1. Idea active/bond (`IdeaData` signals).
2. Ambition/Potential пересчёт.
3. Attempt implement → `attempt_implemented` / `idea_chaged`.
4. `Loot` строит UI из `LootData` (Shard/Spark).

## Связи
- [SYS-08](../systems/SYS-08-mission-gang-loot.md)
- [CONTENT-06](../content/CONTENT-06-mission-gang.md), [CONTENT-07](../content/CONTENT-07-loot-shard-spark.md)

## TODO / открытые вопросы
- Триггер старта миссии из house/continent — TODO: не найден единый entrypoint.
