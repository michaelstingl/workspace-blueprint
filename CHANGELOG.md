# Changelog

Notable changes to the workspace-blueprint. Format: [Keep a Changelog](https://keepachangelog.com); SemVer.

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
