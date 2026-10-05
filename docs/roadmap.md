# Roadmap документации
**Статус:** черновик
**Источники:** расхождения и пробелы, найденные при первом проходе кода

## Ближайшие уточнения (по коду)
1. **`Arbitrator.faction`** — восстановить/задокументировать недостающее поле; без него Discard/Fusion/Punishment/Choices ссылаются в никуда. → [SYS-01](systems/SYS-01-round-phases.md), [TECH-04](tech/TECH-04-phase-choice-action.md)
2. **`s_gameover` vs `is_gameover`** — рассинхрон Mother/Arbitrator. → [TECH-02](tech/TECH-02-mother-hub.md)
3. **Точка старта раунда** — кто вызывает `start_new_round()`. → [FLOW-01](flows/FLOW-01-full-round.md)
4. **GROWTH / RECRUITMENT** — enum есть, в phases нет; связь с Barkeeper recruit. → [SYS-09](systems/SYS-09-guild-masters-agents.md)
5. **ChoiceFusion.next_action** — пробел auto-play. → [SYS-13](systems/SYS-13-advisor-autoplay.md)
6. **Cottage** — data-only; найти call-sites или пометить deprecated. → [CONTENT-12](content/CONTENT-12-cottage-chamber.md)
7. **totems.json** consumer. → [TECH-08](tech/TECH-08-shared-ui-json.md)
8. **Save/Load** — продуктовое решение + TECH. → [TECH-09](tech/TECH-09-save-load.md)
9. **Drag-drop consumers**. → [SYS-14](systems/SYS-14-drag-drop.md)
10. **Поля `*Data`** — CONTENT-доки довести до таблиц полей (второй проход).

## Не найдено / не документировать как системы
- Inventory, Dialogue, полноценный Combat (кроме Attack Shadow).

## Процесс
- Этот набор — coverage draft. Следующая итерация: углубить SYS-01…05 и FLOW-01…04 построчно по phase/choice/action.
