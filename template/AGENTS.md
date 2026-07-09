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
- Project-specific **dev-env / toolchain / CI** setup is current-state knowledge → `docs/` (e.g. `docs/cluster/`, `docs/toolchain/`). It stays with the project; it does not go into the generic tooling or another project's docs.
- Overview: `bun _work/task-kit/board.ts` (`--todos`, `--all`) · upstream movement: `bun _work/task-kit/watch.ts`.
- `_work/` is personal and gitignored: read-only external clones → `_work/reference/` (via `reference-sync`); per-upstream-repo contribution notes → `_work/upstream/<org>/<repo>.md`.
- **Adding project-specific knowledge** (a tool, a testing stack, a dev-env, upstream-contribution notes) — *what goes where, in what shape* → `_work/workspace-blueprint/CONVENTIONS.md`. Copy the skeleton's shape; don't just guess a location.
- **Updating / customizing this workspace** — what's safe to edit vs. what bootstrap refreshes, and why there's no git coupling to the blueprint → see the blueprint README, *Bootstrap & updating* / *No git coupling*.

## Project-specific rules

<!-- Rules that apply only to this project (anonymisation, sensitive areas, language, dates). -->

- <rule-1>
