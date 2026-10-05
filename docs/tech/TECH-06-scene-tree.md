# TECH-06 Scene tree / navigation
**Статус:** черновик
**Источники:** [project.godot](../../project.godot) `run/main_scene`, [entities/world/](../../entities/world/), [entities/isle/isle.gd](../../entities/isle/isle.gd), [entities/continent/continent.gd](../../entities/continent/continent.gd), [entities/world/home/home.gd](../../entities/world/home/home.gd)

## Назначение
Как устроены корневые сцены и переключения Isle/Continent.

## Ключевые сущности / шаги
- `application/run/main_scene` = uid (World/Home дерево).
- `Home` preload isle/continent packed scenes; `change_scene_to_packed`.
- `Isle` / `Continent` — корневые UI контейнеры континента/острова.
- Autoload-данные переживают смену сцены; нодовые UI — нет.

## Связи
- [FLOW-05](../flows/FLOW-05-home-isle-continent.md)
- [SYS-02](../systems/SYS-02-house-cards.md), [SYS-10](../systems/SYS-10-mainland-navigation.md)
- [TECH-01](TECH-01-autoloads.md), [TECH-02](TECH-02-mother-hub.md)

## TODO / открытые вопросы
- Точный путь main_scene uid → файл — сверить в editor/uid cache.
