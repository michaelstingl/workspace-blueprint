# AGENTS.md — workspace-blueprint

Agent entry point. This repo is the **scaffold** for a project workspace (it does not hold project content).

1. Read **[`README.md`](./README.md)** — what it composes (task-kit + docs/specs conventions + the documentation guide) and how to instantiate.
2. To set up a project: `bash bootstrap.sh <project>` — creates the folder scaffold, an `AGENTS.md` from `template/`, and the `_work/task-kit` symlink.
3. Status: incubator — stable parts graduate to reusable plugins/skills; nothing here duplicates its components, it references them. (Current version: [CHANGELOG](./CHANGELOG.md).)

Requires: `git`, and `bun` for the task-kit tooling.
