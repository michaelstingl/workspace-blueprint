#!/usr/bin/env bun
/**
 * reference-sync — manage read-only reference clones from a manifest (no hand-maintained tree).
 *
 * Manifest (JSON, default `<root>/repos.json`): an array of
 *   { org, repo, dir?, depth?: "full"|"shallow", branch?, wiki?: true,
 *     purpose?, routing?: [{ need, path }] }
 *
 * Usage (from a project root):
 *   bun reference-sync.ts                 # render inventory + routing as markdown (default)
 *   bun reference-sync.ts --sync          # clone missing / pull existing
 *   bun reference-sync.ts --check         # report clones present but NOT in the manifest
 *   options: --manifest <path>   --root <dir>   (default root: _work/reference)
 *
 * One source of truth = the manifest. The tool clones/updates AND renders, so a
 * project's CLAUDE.md only points here instead of hand-maintaining a tree/table.
 */
import { execSync } from "node:child_process"
import { existsSync, readFileSync, readdirSync } from "node:fs"
import { join, resolve } from "node:path"

const args = process.argv.slice(2)
const has = (f: string) => args.includes(f)
const opt = (f: string, d: string) => { const i = args.indexOf(f); return i >= 0 ? args[i + 1] : d }

const root = resolve(opt("--root", "_work/reference"))
const manifestPath = resolve(opt("--manifest", join(root, "repos.json")))

type Routing = { need: string; path: string }
type Repo = { org: string; repo: string; dir?: string; depth?: "full" | "shallow"; branch?: string; wiki?: boolean; purpose?: string; routing?: Routing[] }

if (!existsSync(manifestPath)) {
  console.error(`reference-sync: manifest not found at ${manifestPath}\nCreate one (see repos.example.json) or pass --manifest.`)
  process.exit(2)
}
const repos: Repo[] = JSON.parse(readFileSync(manifestPath, "utf8"))
const nameOf = (r: Repo) => r.dir ?? (r.wiki ? `${r.repo}.wiki` : r.repo)
const dirOf = (r: Repo) => join(root, r.org, nameOf(r))
const urlOf = (r: Repo) => `git@github.com:${r.org}/${r.repo}${r.wiki ? ".wiki" : ""}.git`

if (has("--sync")) {
  for (const r of repos) {
    const dir = dirOf(r)
    try {
      if (existsSync(join(dir, ".git"))) {
        execSync(`git -C "${dir}" pull --ff-only -q`, { stdio: "pipe" })
        console.log(`  ✓ updated ${r.org}/${nameOf(r)}`)
      } else {
        const depth = r.depth === "full" ? "" : "--depth 1"
        const branch = r.branch ? `--branch ${r.branch}` : ""
        execSync(`git clone -q ${depth} ${branch} "${urlOf(r)}" "${dir}"`, { stdio: "pipe" })
        console.log(`  ✓ cloned ${r.org}/${nameOf(r)} (${r.depth ?? "shallow"})`)
      }
    } catch (e) {
      console.log(`  ! ${r.org}/${nameOf(r)}: ${(e as Error).message.split("\n")[0]}`)
    }
  }
  process.exit(0)
}

if (has("--check")) {
  const want = new Set(repos.map((r) => `${r.org}/${nameOf(r)}`))
  let drift = 0
  for (const org of existsSync(root) ? readdirSync(root, { withFileTypes: true }).filter((d) => d.isDirectory()) : []) {
    for (const d of readdirSync(join(root, org.name), { withFileTypes: true }).filter((d) => d.isDirectory())) {
      const key = `${org.name}/${d.name}`
      if (!want.has(key)) { console.log(`  ! on disk but not in manifest: ${key}`); drift++ }
    }
  }
  console.log(drift ? `  → ${drift} undocumented clone(s)` : "  ✓ no drift")
  process.exit(drift ? 1 : 0)
}

// default: render inventory + routing (markdown) — paste/point CLAUDE.md here
const byOrg: Record<string, Repo[]> = {}
for (const r of repos) (byOrg[r.org] ??= []).push(r)

let out = "## Reference clones — GENERATED (edit `_work/reference/repos.json`, run `reference-sync.ts`)\n\n```\nreference/\n"
const orgs = Object.entries(byOrg)
orgs.forEach(([org, rs], oi) => {
  out += `├── ${org}/\n`
  rs.forEach((r, i) => {
    const n = nameOf(r)
    const branch = r.branch ? ` (${r.branch})` : ""
    out += `│   ${i === rs.length - 1 ? "└──" : "├──"} ${n.padEnd(24)} # ${r.depth ?? "shallow"}${branch}${r.purpose ? ` — ${r.purpose}` : ""}\n`
  })
})
out += "```\n\nSync: `bun _work/workspace-blueprint/env-tools/reference-sync.ts --sync` · drift-check: `--check`\n"

const routing = repos.flatMap((r) => (r.routing ?? []).map((rt) => rt))
if (routing.length) {
  out += '\n### Routing — "where do I look up X?"\n\n| Need | Look here |\n|---|---|\n'
  for (const rt of routing) out += `| ${rt.need} | \`${rt.path}\` |\n`
}
console.log(out)
