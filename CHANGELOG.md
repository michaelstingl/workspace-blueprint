# Changelog

Notable changes to the workspace-blueprint. Format: [Keep a Changelog](https://keepachangelog.com); SemVer.

## 0.9.1

### Changed
- **De-vapor + drop a stray internal reference from the public docs.** README/AGENTS no longer advertise a "method-skills layer" as if it exists (it is planned, not built — now labelled as such) nor call the docs/specs gist a grand "W3C-PROV documentation architecture" (described plainly as an external documentation guide). A leftover "PD skills" reference in the README tree is genericised to "conventions". Doc-only; the repo now advertises only what it delivers.

## 0.9.0

### Changed
- **bootstrap is safe by default (dry-run); mutating requires `--apply`.** Running `bash bootstrap.sh <project>` now only prints the plan and changes nothing — so reading it, or an agent running it casually on a "have a look" instruction, can no longer surprise you by scaffolding dirs, cloning repos, and installing hooks. Pass `--apply` (or `-y`) to actually perform it. Consequences are shown before any change, in the tool itself, rather than relying on the caller to know them.

## 0.8.0

### Added
- **bootstrap seeds a `CLAUDE.md -> AGENTS.md` symlink.** A harness that auto-loads `CLAUDE.md` (e.g. Claude Code) then still picks up the routing head that lives in `AGENTS.md` — without it a fresh session may never read the entry point and the agent fails to orient. Skipped if the project already has its own `CLAUDE.md` (not clobbered). Makes "a new agent re-orients every session" reliable rather than harness-dependent.

## 0.7.0

### Added
- **`CONVENTIONS.md` — grammar for adding project-specific knowledge to an instance.** Codifies *what goes where, in what shape* for the knowledge an instance accumulates, primarily **testing & tooling** (per-tool notes in `docs/toolchain/<tool>.md`; dev-env/CI in `docs/`; a test-ladder in `docs/TEST-STACKS.md`), secondarily **upstream & contribution** (per-repo notes in `_work/upstream/<org>/<repo>.md`, splitting *enforced* from *convention*). Each pattern ships a **neutral skeleton** to copy — the principle is *show the shape, don't just name the slot*, since naming a slot alone has led instances to diverge (flat files, ad-hoc testing). `template/AGENTS.md` points at it. Generic only; real domain content lives in the instance. An auto-firing skill is out of scope (deferred).

### Changed
- **README update/customize model made unmistakable.** A new **No git coupling** note states plainly that a project has its own git remote and the blueprint is not a remote/fork/upstream of it. The dense "Linked vs copied" sentence becomes a scannable table (safe-to-edit vs. refreshed-on-re-run) with an explicit warning that local edits to the managed files (`hooks/pre-commit`, `lefthook.yml`) are overwritten on the next bootstrap. `template/AGENTS.md` gains a pointer to this model (an agent often reads only `AGENTS.md`). Doc-only; no scaffold/behaviour change.

## 0.6.0

### Added
- **Named convention: what a project instance holds vs references.** README and `template/AGENTS.md` now make explicit that the instance is the real parent of its content, and provide the slots for both: `docs/` holds the project's own **dev-env / toolchain / CI** setup (e.g. `docs/cluster/`, `docs/toolchain/`) alongside its current-state knowledge; `_work/reference/` holds read-only external clones (via `reference-sync`); `_work/upstream/<org>/<repo>.md` holds per-upstream-repo contribution notes. `reference/` is what you read, `upstream/<org>/<repo>.md` is how you contribute back. Codifies a convention already lived across multiple projects. Doc-only; no scaffold/behaviour change.

## 0.5.0

### Added
- `env-tools/reference-sync.ts` (bun) + `env-tools/repos.example.json` — manage read-only reference clones from a JSON manifest (`_work/reference/repos.json`): `--sync` clones/updates, default renders the inventory **+ a "where do I look up X?" routing table**, `--check` reports drift. A project's CLAUDE.md points to the tool instead of hand-maintaining a tree/table.

## 0.4.0

### Changed
- bootstrap **clones** task-kit + workspace-blueprint into `_work/` by default (update via `git pull` + re-run); `--link` keeps the symlink mode for co-developing the tools. Clone-based consumption is portable/self-contained (no symlink/layout assumption) — fitting now that task-kit is released. `_work/` is gitignored.

### Added
- bootstrap stamps `_work/.workspace-blueprint-version` (drift visibility).
- README "Bootstrap & updating" — the linked-vs-copied update model.

## 0.3.1

### Changed
- `.gitignore`: ignore local dev/test scratch (`_work/`, root `project-*/`) so the blueprint can be exercised against throwaway instances while staying generic — project-specific content belongs in the instantiated project, not the template.

## 0.3.0

### Changed
- Pre-commit gate is now **gitleaks + lefthook** (primary, battle-tested): `lefthook.yml` runs `gitleaks protect --staged` (secrets) + an internal-ref denylist check. The hand-rolled `hooks/pre-commit` becomes the **zero-dep fallback** (gains `--deny-only` for the lefthook step). `bootstrap.sh` installs whichever is available. Established practice (gitleaks/lefthook + secrets-out-of-repo), not a bespoke invention.

### Added
- `lefthook.yml`.

## 0.2.0

### Added
- `hooks/pre-commit` — a portable secret / internal-ref guard: scans staged added lines for common secret patterns (GitHub/Slack/OpenAI/AWS/Google tokens, private keys, `key=secret` assignments) plus project-specific patterns; blocks the commit on a match (bypass with `--no-verify`). It excludes its own pattern file from the scan.
- `.git-deny-patterns.example` — template for per-project deny patterns. The real `.git-deny-patterns` is **gitignored** (it lists the internal names you're hiding — committing it would defeat the purpose); a team shares one via `$GIT_DENY_PATTERNS` pointing at a private/synced file.
- `.gitignore` (ignores `.git-deny-patterns`, `.DS_Store`).
- `bootstrap.sh` now installs the hook into the project's `.git/hooks/`, seeds `.git-deny-patterns`, and adds it to the project's `.gitignore`.

## 0.1.0

### Added
- Initial skeleton: README (vision + composition + layering + roadmap), `AGENTS.md` (agent entry), `template/` (project-workspace scaffold incl. a project `AGENTS.md`), `bootstrap.sh` (instantiate a project: scaffold + AGENTS + task-kit symlink), CC0 `LICENSE`.
- Composes (by reference): [task-kit](https://github.com/michaelstingl/task-kit), a method-skills layer, and the W3C-PROV documentation architecture.
