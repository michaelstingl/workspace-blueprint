# Conventions: adding project-specific knowledge to an instance

The blueprint is the mold; a project instance is where project-specific knowledge actually
lives. This file is the **grammar** for adding that knowledge: *what* goes *where*, and in
*what shape*. It is generic — the real, domain-specific content lives in your instance, never
here.

Your instance's `AGENTS.md` points at this file; read it when you are about to document a
tool, a testing setup, a dev-env, or how you contribute to an upstream repo.

## Principle: show the shape, don't just name the slot

Naming a slot ("put toolchain notes in `docs/toolchain/`") is not enough — in practice
instances diverge (notes land flat, testing lands ad-hoc). So each pattern below gives a
**neutral skeleton**: copy its shape, then fill it with your real content. The skeleton shows
the structure; the mold never carries domain examples.

Two homes, by nature of the knowledge:

- **Held (committed)** — team knowledge that belongs to the project: `docs/`, `specs/`.
- **Referenced (personal, gitignored `_work/`)** — read-only clones and per-upstream notes.

---

## Testing & tooling (primary)

### Toolchain notes — one file per tool

**Where:** `docs/toolchain/<tool>.md` (committed). One file per tool, not one big page.
**Shape:**

```md
# <tool> — <one line: what it's for here>

## Purpose
When and why this project reaches for <tool>.

## Commands
The exact invocations that work in this repo (copy-paste runnable), incl. flags/paths.

## Gotchas
The non-obvious traps — version pins, env vars, ordering, things that bit us once.
```

### Dev-env / CI / cluster setup

**Where:** `docs/` (committed) — e.g. `docs/cluster/`, `docs/ci/`. This is current-state team
knowledge, specific to the project; it does not belong in the generic tooling or another
project's docs. Structure by concern, one file per topic.

### Testing stack / conventions — the test ladder

**Where:** `docs/TEST-STACKS.md` (committed), or `docs/testing/` if it grows.
**Why:** so an agent picks the *right* verification for a given change instead of improvising.
**Shape** — a ladder (cheapest rung first) plus a "which rung for which change" note:

```md
# Test stacks — how we verify a change

| Rung | What it exercises | Tools | Cost |
|------|-------------------|-------|------|
| 0    | <unit / typecheck> | <…>  | fast |
| 1    | <integration>      | <…>  | med  |
| 2    | <end-to-end / real deploy> | <…> | slow |

## Which rung for which change
- <kind of change> → <rung(s)>, because <reason>.

## Reproducibility
How to get a clean, repeatable run (fixtures, seeds, throwaway resources).
```

---

## Upstream & contribution (secondary)

### Per-upstream-repo notes — one file per repo

**Where:** `_work/upstream/<org>/<repo>.md` (personal, gitignored). One file per repo, because
CI, DCO, and review rules differ per repo; `<org>/README.md` holds the genuinely org-wide bits.
**Key split — separate what blocks from what's nice:**

```md
# <org>/<repo> — contributing

## Enforced (CI / a bot blocks the PR)
Lint version + command, required checks, DCO/sign-off, commit/PR title rules, changelog
fragment — anything that fails the PR if missing.

## Convention (match when cheap)
House style, comment/log idioms, test layout — match the neighbouring code, but nothing
here blocks a PR.

## Mechanics
Branch/fork model, how to run the project's CI locally, how a PR is opened here.
```

Keep this distinct from `_work/reference/<org>/<repo>` — `reference/` is what you *read*;
`upstream/<org>/<repo>.md` is how you *contribute back*.

---

## The rest (already covered elsewhere)

These accumulation patterns exist too, but their conventions live in the composed tools —
don't duplicate them here:

- **Read-only reference clones + "where do I look up X?" routing** → `_work/reference/`, managed
  by `reference-sync` (see `env-tools/`).
- **Per-PR journal** — one short entry per PR → `journal/` (see `template/AGENTS.md`).
- **Per-problem work / triage** → a kit under `_work/kits/` (see task-kit).
