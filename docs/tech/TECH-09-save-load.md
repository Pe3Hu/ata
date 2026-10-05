# TECH-09 Save / Load
**Статус:** stub
**Источники:** grep `FileAccess` / save по `*.gd` — найден только [global/Helper.gd](../../global/Helper.gd) (`names.json` READ) и `Digest` load intro `.tres`

## Назначение
Зафиксировать отсутствие savegame API.

## Ключевые сущности / шаги
- TODO: не найдено serialize/deserialize сессии Mother/Arbitrator.
- Есть только чтение статических JSON/Resource при init.

## Связи
- [TECH-02](TECH-02-mother-hub.md), [TECH-03](TECH-03-data-pattern.md)
- [docs/roadmap.md](../roadmap.md)

## TODO / открытые вопросы
- Нужен ли save — продуктовый вопрос; технически большинство state в RefCounted.
