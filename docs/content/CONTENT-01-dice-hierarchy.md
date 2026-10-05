# CONTENT-01 DiceData hierarchy
**Статус:** черновик
**Источники:** [entities/dice/datas/dice_data.gd](../../entities/dice/datas/dice_data.gd), [entities/dice/datas/intro/intro_data.gd](../../entities/dice/datas/intro/intro_data.gd), [entities/dice/datas/matter/matter_data.gd](../../entities/dice/datas/matter/matter_data.gd), [entities/dice/datas/pressure/pressure_dice_data.gd](../../entities/dice/datas/pressure/pressure_dice_data.gd), [entities/dice/datas/punishment/punishment_data.gd](../../entities/dice/datas/punishment/punishment_data.gd), [entities/dice/datas/verse/verse_data.gd](../../entities/dice/datas/verse/verse_data.gd)

## Назначение
Схема типов кубиков (не каталог конкретных значений `.tres`).

## Ключевые сущности / шаги
- `DiceData` extends `Resource`: `values: Array[int]`, `result`, `roll_result()`, `get_sum()`.
- Подклассы Resource: Intro / Matter / Pressure / Punishment / Verse.
- Инстансы данных лежат в `entities/dice/datas/{intro,matter,pressure,punishment,verse}/*.tres` (контент-данные, не схема).

## Связи
- [SYS-11](../systems/SYS-11-dice.md), [TECH-03](../tech/TECH-03-data-pattern.md)
- [CONTENT-08](CONTENT-08-kernel-types.md) (pressure), [SYS-07](../systems/SYS-07-stepladder.md)

## TODO / открытые вопросы
- Поля, уникальные для каждого подтипа — перечислить из тонких subclass-файлов.
