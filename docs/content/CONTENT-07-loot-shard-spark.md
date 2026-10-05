# CONTENT-07 Loot / Shard / Spark
**Статус:** черновик
**Источники:** [entities/isle/loot/loot_data.gd](../../entities/isle/loot/loot_data.gd), [entities/isle/loot/shard/shard_data.gd](../../entities/isle/loot/shard/shard_data.gd), [entities/isle/loot/spark/spark_data.gd](../../entities/isle/loot/spark/spark_data.gd)

## Назначение
Схема лута миссии (не общий inventory).

## Ключевые сущности / шаги
- `LootData` → коллекции shard/spark.
- UI `Loot` / `Shard` / `Spark` + соответствующие `*Data`.

## Связи
- [SYS-08](../systems/SYS-08-mission-gang-loot.md), [FLOW-08](../flows/FLOW-08-mission-attempt-loot.md)
- [CONTENT-06](CONTENT-06-mission-gang.md)

## TODO / открытые вопросы
- Поля shard/spark (matter, value) — TODO из файлов.
- Persistence лута — TODO: не найдено (см. TECH-09).
