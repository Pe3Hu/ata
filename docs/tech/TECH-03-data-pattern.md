# TECH-03 Data pattern: Resource vs RefCounted
**Статус:** черновик
**Источники:** grep `extends Resource` / `*_data.gd` по репозиторию

## Назначение
Описание паттерна `Foo` (Node/UI) + `FooData` (состояние) и где реально используется Godot Resource.

## Ключевые сущности / шаги
**True Resource:**
- DiceData (+ subtypes), ScenarioData, SourceData, IntentionData, OpportunityData
- Phase, Choice (global)

**Большинство `*_data.gd`:** `extends RefCounted` (или промежуточный data-класс), не сериализуются как `.tres`.

Actions: `ActionData` hierarchy — `RefCounted`.

## Связи
- [CONTENT-01](../content/CONTENT-01-dice-hierarchy.md), [TECH-04](TECH-04-phase-choice-action.md), [TECH-09](TECH-09-save-load.md)
- [SYS-11](../systems/SYS-11-dice.md)

## TODO / открытые вопросы
- Нужен ли перевод ключевых RefCounted→Resource для save — открытый дизайн-вопрос.
