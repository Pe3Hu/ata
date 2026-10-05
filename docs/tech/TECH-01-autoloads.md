# TECH-01 Autoloads
**Статус:** черновик
**Источники:** [project.godot](../../project.godot) секция `[autoload]`, [global/](../../global/)

## Назначение
Реестр и порядок глобальных синглтонов Godot.

## Ключевые сущности / шаги
Порядок из project.godot:
1. `Bozo` → `global/Bozo.gd` — enums
2. `Catalog` → `global/Catalog.gd` — константы
3. `Helper` → Helper.gd — утилиты/RNG
4. `Digest` → Digest.gd — lookup + intro load
5. `Arbitrator` — фазы раунда
6. `Gear` — tempo/pause/auto_play
7. `Advisor` — auto choices
8. `Mother` — session data hub

## Связи
- [TECH-02](TECH-02-mother-hub.md), [TECH-04](TECH-04-phase-choice-action.md), [TECH-07](TECH-07-gear-animation.md)
- [SYS-01](../systems/SYS-01-round-phases.md), [SYS-13](../systems/SYS-13-advisor-autoplay.md)

## TODO / открытые вопросы
- Helper/Digest/Arbitrator/Gear/Advisor/Mother подключены через uid — пути сверить с filesystem_cache при необходимости.
