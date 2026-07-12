# workspace-blueprint

> The scaffold for a project workspace — folders, conventions, and tooling. From one template a new project gets a consistent, agent-readable workspace: task-kit for per-problem kits, a set of docs/specs conventions, and a secret-guarded git setup.

**Status:** incubator / WIP — the grundgerüst matures here; stable parts graduate into reusable plugins/skills. Current version: [CHANGELOG](./CHANGELOG.md) · [releases](https://github.com/michaelstingl/workspace-blueprint/releases).

## What it composes (references, does not duplicate)
- **[task-kit](https://github.com/michaelstingl/task-kit)** — the per-problem kit primitive (`_work/kits/`) + board/scaffolder/watch tooling.
- **Conventions for how you work** — `CONVENTIONS.md` (where project-specific knowledge goes), the `docs/`/`specs/`/`plans/`/`journal/` roles, and a secret-guarded git setup — wired in per project. *(An auto-firing method-skills layer — the WORKFLOW / verify-before-claim discipline as skills — is planned, not here yet; see Roadmap.)*
- **A docs/specs documentation guide** (PROV-inspired) — currently an external [gist](https://gist.github.com/michaelstingl/d915a88fad79469796320f5bd6d34821); migrating into versioned templates here (Roadmap).

## A project workspace (instantiated from `template/`)
```
<project>/
  AGENTS.md             entry → guide + task-kit + conventions
  docs/  specs/  plans/  committed knowledge (current state / intent / multi-step)
                        docs/ also holds this project's dev-env / toolchain / CI (e.g. docs/cluster/)
  journal/              per-PR journal (one short entry per PR)
  _work/                personal, gitignored
    kits/  kit-archive/
    task-kit -> …        symlink to the kit primitive
    reference/          read-only external clones (managed by reference-sync)
    upstream/<org>/<repo>.md   per-upstream-repo contribution notes
```

### What the instance holds vs references

The blueprint is the mold; **a project instance is the real parent of its content** — so it either *holds* project-specific knowledge or *references* it, and the mold provides the slots for both.

- **Holds (committed):** `specs/` intent · `docs/` current-state team knowledge — *including the project's own dev-env / toolchain / CI setup* (e.g. `docs/cluster/`, `docs/toolchain/`). This is project-specific: it does not belong in the generic tooling, nor in another project's docs.
- **References (personal, under gitignored `_work/`):** read-only external repos in `_work/reference/` (managed by `reference-sync`, with a "where do I look up X?" routing table); and per-upstream-repo contribution notes — DCO/RFC/branch mechanics for a repo you send PRs to — in `_work/upstream/<org>/<repo>.md`.

`reference/` is what you *read*; `upstream/<org>/<repo>.md` is how you *contribute back*. Keeping them distinct stops upstream mechanics from leaking into read-only reference notes.

## Bootstrap & updating

```sh
bash bootstrap.sh <project>                  # DRY-RUN — print what it would do, change nothing (safe)
bash bootstrap.sh --apply <project>          # scaffold + CLONE task-kit & workspace-blueprint into _work/ (idempotent)
bash bootstrap.sh --apply --link <project>   # symlink them to sibling clones instead (for co-developing the tools)
```

**Safe by default:** without `--apply`, bootstrap only prints its plan and changes nothing — so reading or casually running it never mutates your filesystem.

The tools live in `_work/` (gitignored). **Update** by pulling them and re-running bootstrap:

```sh
git -C _work/task-kit pull && git -C _work/workspace-blueprint pull
bash _work/workspace-blueprint/bootstrap.sh --apply .   # refreshes copied generic parts (hooks, lefthook.yml);
                                                #   your AGENTS.md / .git-deny-patterns / content stay
brew upgrade gitleaks lefthook                  # secret-detection updates come from gitleaks
```

**No git coupling.** Your project has its **own** git remote; the blueprint is not a remote, fork, or upstream of it. The tools live as gitignored clones (or `--link` symlinks) under `_work/` and update independently — you never `git pull` the blueprint *into* your project.

**What you can edit, and what gets refreshed:**

| Safe to edit — bootstrap never touches it | Managed — overwritten on every re-run |
|---|---|
| `AGENTS.md`, `.git-deny-patterns`, and all your content (`docs/` `specs/` `plans/` `journal/` `_work/kits/`) | `hooks/pre-commit`, `lefthook.yml` |

Customize the left column freely. **Do not edit the right column locally — your changes are overwritten on the next bootstrap;** change that behaviour in the blueprint itself, or (for your own deny-list) in `.git-deny-patterns`. The **tools** (task-kit, workspace-blueprint) are pull-updated; **gitleaks** self-updates via brew; the blueprint version is stamped in `_work/.workspace-blueprint-version`.

## Pre-commit secret guard

**Primary (recommended): [gitleaks](https://github.com/gitleaks/gitleaks) via [lefthook](https://github.com/evilmartians/lefthook)** — the battle-tested secret scanner + hook manager. `lefthook.yml` runs `gitleaks protect --staged` (tokens/keys/entropy) plus an internal-ref check. Setup once per machine: `brew install lefthook gitleaks && lefthook install`.

**Zero-dep fallback:** if those aren't installed, `hooks/pre-commit` (a small hand-rolled regex scanner) covers it — weaker (no entropy detection), no install needed. `bootstrap.sh` installs whichever is available. Bypass deliberately with `git commit --no-verify`.

Together they automate the manual leak-scan that keeps secrets and internal references out of a (public) repo.

**The denylist is never committed.** The internal names you want to hide go in `.git-deny-patterns`, which is **gitignored** (only the `.example` with placeholders is shared) — otherwise the repo would publish exactly what you're hiding. To share a denylist across a team without committing it, keep it in a private/synced folder and point the hook at it: `export GIT_DENY_PATTERNS=/path/to/shared/deny-patterns`. Generic secret patterns live in the hook itself (no secrets there, safe to commit).

## Layering (no monorepo, no ownership)
**workspace-blueprint = the mold.** A **project = the instance** (the real parent of its kits). **task-kit = a standalone component** the blueprint composes. A layered family of independent pieces, wired by reference (symlink) — not merged.

## Env-tools

- **`env-tools/reference-sync.ts`** (bun) — manage read-only reference clones from a
  manifest (`_work/reference/repos.json`) instead of a hand-maintained tree/table:
  `--sync` clones/updates, default renders the inventory **+ a "where do I look up X?"
  routing table**, `--check` reports drift. A project's CLAUDE.md just points here.
  See `env-tools/repos.example.json`.

## Roadmap
- Env-tools: `repos-sync` (any repo collection, `--root`) to join `reference-sync`; more manifest templates.
- Migrate the W3C-PROV gist into versioned templates here.
- Graduate stable parts → reusable plugins/skills (bootstrap, env-tools, conventions).

## License
CC0 — public domain. No attribution required.
