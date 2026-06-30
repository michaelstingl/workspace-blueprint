# workspace-blueprint

> The scaffold for a project workspace — folders, conventions, and tooling — that **composes** task-kit, a method-skills layer, and the W3C-PROV documentation architecture. A new project gets a consistent, agent-readable workspace from one template.

**Status:** 0.1.0 — incubator / WIP. The grundgerüst matures here; stable parts graduate into reusable plugins/skills.

## What it composes (references, does not duplicate)
- **[task-kit](https://github.com/michaelstingl/task-kit)** — the per-problem kit primitive (`_work/kits/`) + board/scaffolder/watch tooling.
- **A method-skills layer** — spec-driven / test-first work, a per-PR journal, docs & specs conventions, tutorials (the generic "how we work"; wired in per project).
- **[W3C-PROV documentation architecture](https://gist.github.com/michaelstingl/d915a88fad79469796320f5bd6d34821)** — the `docs/`/`specs/`/`references` conventions.

## A project workspace (instantiated from `template/`)
```
<project>/
  AGENTS.md             entry → guide + task-kit + PD skills
  docs/  specs/  plans/  committed knowledge (current state / intent / multi-step)
  journal/              per-PR journal (one short entry per PR)
  _work/                personal, gitignored
    kits/  kit-archive/
    task-kit -> …        symlink to the kit primitive
```

## Bootstrap
```sh
bash bootstrap.sh <path-to-a-project>     # scaffold dirs + AGENTS.md + the task-kit symlink (idempotent)
```

## Pre-commit secret guard

**Primary (recommended): [gitleaks](https://github.com/gitleaks/gitleaks) via [lefthook](https://github.com/evilmartians/lefthook)** — the battle-tested secret scanner + hook manager. `lefthook.yml` runs `gitleaks protect --staged` (tokens/keys/entropy) plus an internal-ref check. Setup once per machine: `brew install lefthook gitleaks && lefthook install`.

**Zero-dep fallback:** if those aren't installed, `hooks/pre-commit` (a small hand-rolled regex scanner) covers it — weaker (no entropy detection), no install needed. `bootstrap.sh` installs whichever is available. Bypass deliberately with `git commit --no-verify`.

Together they automate the manual leak-scan that keeps secrets and internal references out of a (public) repo.

**The denylist is never committed.** The internal names you want to hide go in `.git-deny-patterns`, which is **gitignored** (only the `.example` with placeholders is shared) — otherwise the repo would publish exactly what you're hiding. To share a denylist across a team without committing it, keep it in a private/synced folder and point the hook at it: `export GIT_DENY_PATTERNS=/path/to/shared/deny-patterns`. Generic secret patterns live in the hook itself (no secrets there, safe to commit).

## Layering (no monorepo, no ownership)
**workspace-blueprint = the mold.** A **project = the instance** (the real parent of its kits). **task-kit = a standalone component** the blueprint composes. A layered family of independent pieces, wired by reference (symlink) — not merged.

## Roadmap
- Env-tools: generic `repos-sync.sh --root` (one tool for any repo collection) + `reference-sync.sh` + manifest template.
- Migrate the W3C-PROV gist into versioned templates here.
- Graduate stable parts → reusable plugins/skills (bootstrap, env-tools, conventions).

## License
CC0 — public domain. No attribution required.
