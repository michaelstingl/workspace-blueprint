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

## Layering (no monorepo, no ownership)
**workspace-blueprint = the mold.** A **project = the instance** (the real parent of its kits). **task-kit = a standalone component** the blueprint composes. A layered family of independent pieces, wired by reference (symlink) — not merged.

## Roadmap
- Env-tools: generic `repos-sync.sh --root` (one tool for any repo collection) + `reference-sync.sh` + manifest template.
- Migrate the W3C-PROV gist into versioned templates here.
- Graduate stable parts → reusable plugins/skills (bootstrap, env-tools, conventions).

## License
CC0 — public domain. No attribution required.
