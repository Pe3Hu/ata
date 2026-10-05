# FLOW-05 Home: Isle ↔ Continent
**Статус:** черновик
**Источники:** [entities/world/home/home.gd](../../entities/world/home/home.gd), [entities/world/world.gd](../../entities/world/world.gd), [entities/isle/isle.gd](../../entities/isle/isle.gd), [entities/continent/continent.gd](../../entities/continent/continent.gd), [project.godot](../../project.godot)

## Назначение
Переключение между сценами острова и континента через Home UI.

## Ключевые сущности / шаги
1. Main scene из project.godot → World/Home (uid main_scene).
2. `Home._on_isle_button_pressed` → `change_scene_to_packed(isle_scene)`.
3. `Home._on_continent_button_pressed` → continent scene.
4. Если `Arbitrator.is_gameover` в `_ready` — автопереход на continent.

## Связи
- [SYS-02](../systems/SYS-02-house-cards.md), [SYS-09](../systems/SYS-09-guild-masters-agents.md), [SYS-10](../systems/SYS-10-mainland-navigation.md)
- [TECH-06](../tech/TECH-06-scene-tree.md)
- [FLOW-06](FLOW-06-mainland-travel.md)

## TODO / открытые вопросы
- Сохраняется ли Mother-state при `change_scene` — да (autoload), UI-state сцен — нет (стандарт Godot).
