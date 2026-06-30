# AGENTS.md — <project>

> **Architecture:** W3C-PROV documentation architecture + the task-kit working convention.
> **Required reading (first contact, in order):**
>   1. This file
>   2. The architecture guide — https://gist.github.com/michaelstingl/d915a88fad79469796320f5bd6d34821
>   3. task-kit — https://github.com/michaelstingl/task-kit (kits live in `_work/kits/`)

## What this project is

<one short paragraph: what it is, who it's for, the horizon>

## How we work

- Per-problem work lives in a **kit** under `_work/kits/<slug>/`: `bun _work/task-kit/new-kit.ts <slug> --title "…"` (add `--contribution` for a kit that yields an issue/PR).
- **`specs/`** intent · **`docs/`** current state (team knowledge) · **`plans/`** multi-step plans · **`journal/`** per-PR learnings (one short entry per PR).
- Overview: `bun _work/task-kit/board.ts` (`--todos`, `--all`) · upstream movement: `bun _work/task-kit/watch.ts`.
- `_work/` is personal and gitignored.

## Project-specific rules

<!-- Rules that apply only to this project (anonymisation, sensitive areas, language, dates). -->

- <rule-1>
