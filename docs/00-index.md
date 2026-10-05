# ata — индекс документации (черновик)

**Стек:** Godot **4.7**, **GDScript** ([project.godot](../project.godot)).
**Статус:** первое приближение; покрытие важнее полноты.
**Корни кода:** `entities/`, `global/`, `shared/` (игнор: `.godot/`, `.import/`, ассеты, `*.uid`).

## Чего нет в коде (не заводили SYS)
- Классический inventory — TODO: не найдено (есть только mission Loot).
- Dialogue — TODO: не найдено.
- Save/Load сессии — см. [TECH-09](tech/TECH-09-save-load.md).

## Systems
- [SYS-01](systems/SYS-01-round-phases.md) — Раунд и фазы
- [SYS-02](systems/SYS-02-house-cards.md) — House / карты
- [SYS-03](systems/SYS-03-odeum.md) — Odeum / canto
- [SYS-04](systems/SYS-04-arsenal-fusion.md) — Arsenal / fusion
- [SYS-05](systems/SYS-05-attack-shadow.md) — Attack Shadow
- [SYS-06](systems/SYS-06-kernel-economy.md) — Kernel / экономика
- [SYS-07](systems/SYS-07-stepladder.md) — Stepladder
- [SYS-08](systems/SYS-08-mission-gang-loot.md) — Mission / loot
- [SYS-09](systems/SYS-09-guild-masters-agents.md) — Guild / agents
- [SYS-10](systems/SYS-10-mainland-navigation.md) — Mainland
- [SYS-11](systems/SYS-11-dice.md) — Dice
- [SYS-12](systems/SYS-12-welkin.md) — Welkin
- [SYS-13](systems/SYS-13-advisor-autoplay.md) — Advisor
- [SYS-14](systems/SYS-14-drag-drop.md) — Drag-drop *(stub)*

## Flows
- [FLOW-01](flows/FLOW-01-full-round.md) — Полный раунд
- [FLOW-02](flows/FLOW-02-decision-attack.md) — Decision → attack
- [FLOW-03](flows/FLOW-03-discard-fusion.md) — Discard → fusion
- [FLOW-04](flows/FLOW-04-punishment-debts.md) — Punishment → долги
- [FLOW-05](flows/FLOW-05-home-isle-continent.md) — Home Isle↔Continent
- [FLOW-06](flows/FLOW-06-mainland-travel.md) — Mainland travel
- [FLOW-07](flows/FLOW-07-guild-task-agent.md) — Guild task/agent
- [FLOW-08](flows/FLOW-08-mission-attempt-loot.md) — Mission → loot

## Content (схемы)
- [CONTENT-01](content/CONTENT-01-dice-hierarchy.md) — DiceData hierarchy
- [CONTENT-02](content/CONTENT-02-card-echo-shadow.md) — Card / Echo / Shadow
- [CONTENT-03](content/CONTENT-03-house-room-scenario.md) — House / Room / Scenario
- [CONTENT-04](content/CONTENT-04-odeum-hymn-canto.md) — Odeum / Hymn / Canto
- [CONTENT-05](content/CONTENT-05-arsenal-anvil.md) — Arsenal / Anvil
- [CONTENT-06](content/CONTENT-06-mission-gang.md) — Mission / Gang
- [CONTENT-07](content/CONTENT-07-loot-shard-spark.md) — Loot / Shard / Spark
- [CONTENT-08](content/CONTENT-08-kernel-types.md) — Kernel types
- [CONTENT-09](content/CONTENT-09-guild-types.md) — Guild types
- [CONTENT-10](content/CONTENT-10-mainland-types.md) — Mainland types
- [CONTENT-11](content/CONTENT-11-biome-source.md) — Biome / Source
- [CONTENT-12](content/CONTENT-12-cottage-chamber.md) — Cottage / Chamber *(stub)*

## Tech
- [TECH-01](tech/TECH-01-autoloads.md) — Autoloads
- [TECH-02](tech/TECH-02-mother-hub.md) — Mother hub
- [TECH-03](tech/TECH-03-data-pattern.md) — Resource vs RefCounted
- [TECH-04](tech/TECH-04-phase-choice-action.md) — Phase / Choice / Action
- [TECH-05](tech/TECH-05-signals-bus.md) — Signals bus
- [TECH-06](tech/TECH-06-scene-tree.md) — Scene tree
- [TECH-07](tech/TECH-07-gear-animation.md) — Gear / animation
- [TECH-08](tech/TECH-08-shared-ui-json.md) — Shared UI / JSON
- [TECH-09](tech/TECH-09-save-load.md) — Save / Load *(stub)*

## Meta
- [glossary.md](glossary.md)
- [roadmap.md](roadmap.md)
