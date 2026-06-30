# Changelog

Notable changes to the workspace-blueprint. Format: [Keep a Changelog](https://keepachangelog.com); SemVer.

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
