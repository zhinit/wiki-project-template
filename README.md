# wiki-project-template

A starter template for projects built around an LLM-maintained wiki,
following Andrej Karpathy's LLM Wiki pattern:
archive primary sources immutably, have the agent distill them into an
interlinked wiki of concept pages, and keep your own conclusions and results
strictly separate from the research.

Shared instructions and workflows work with agents that read `AGENTS.md`.
[Claude Code](https://claude.com/claude-code) command and hook adapters and
Codex skill wrappers are included.

## How it works

Information lives in exactly one place:

| Location | Contents | Rules |
|---|---|---|
| `raw/` | Primary sources (`html/` originals, `md/` conversions) | Immutable once saved |
| `wiki/` | Distilled research | Neutral; every claim cites a file in `raw/md/`; no opinions or own results |
| `docs/` | Project conclusions, decisions, methodology | The only place opinions go |
| `<project-dirs>/` | Your code, data, experiments, results | Anything produced by your own work |

The flow: research a topic → sources are archived to `raw/` → distilled into
cited, interlinked pages in `wiki/` → your conclusions from that research go
in `docs/` → your code and results go in project directories.

The wiki is the agent's knowledge base. When you ask questions, it answers
from the wiki and cites pages. If the project files do not cover it, it
explicitly labels an answer from general knowledge and suggests `/research`.

## Getting started

1. Clone or copy this template into a new project directory.
2. Edit `AGENTS.md`: fill in the project name, the one-paragraph description,
   and replace `<project-dirs>` with the directories your project needs
   (e.g. `src/`, `analysis/`, `db/`).
3. Start your agent and request `research <your first topic>`. In Claude Code,
   run `/research <your first topic>`. In Codex, use `$research <your first topic>`.

## Commands

Claude uses the slash commands below. Codex uses `$research <topic>`,
`$lint-wiki`, and `$retract-source <file>` for the same workflows.

- **`/research <topic>`** — searches the web and arXiv for primary sources,
  presents candidates for approval, archives them to `raw/`, and ingests them
  into the wiki as topic pages. A single source may touch 10–15
  pages.
- **`/lint_wiki`** — audits the wiki for contradictions, orphan pages, broken
  links, uncited claims, stale claims, format violations, and
  separation-of-concerns violations. Reports first; fixes only on approval.
- **`/retract_source <file>`** — removes a bad source from `raw/` and cleans
  up every wiki claim that cites it. Reports the blast radius first; deletes
  only on approval. The only sanctioned way to delete from `raw/`.

## Wiki conventions

- One H1 title per page, prose organized into `##` sections.
- Every factual claim carries an inline citation `(source: <file>.md)`
  pointing to a file in `raw/md/` — never to another wiki page.
- Pages link to each other with `[[page-name]]` or `[[page-name|display text]]`.
- `wiki/index.md` lists every page with a one-line description.
- `wiki/log.md` is an append-only log of every wiki operation.

## What's in the template

```
AGENTS.md                       -- canonical project instructions and workflow map
CLAUDE.md -> AGENTS.md          -- Claude instruction entry point
wiki/                          -- index.md and log.md, empty to start
raw/                           -- html/ and md/, empty to start
docs/                          -- empty to start
.agents/
  skills/research/SKILL.md     -- Codex $research wrapper
  skills/lint-wiki/SKILL.md    -- Codex $lint-wiki wrapper
  skills/retract-source/SKILL.md -- Codex $retract-source wrapper
  workflows/research.md        -- shared research workflow
  workflows/lint_wiki.md       -- shared wiki audit workflow
  workflows/retract_source.md  -- shared source retraction workflow
  style-reminder.md            -- condensed project rules
  hooks/protect-raw.sh          -- shared protection logic
.claude/
  commands/*.md                -- symlinks to shared workflows
  settings.json                -- Claude hook registration
  hooks/protect-raw.sh          -- Claude input adapter
```

`AGENTS.md` maps workflow names to their shared files. Agents can follow those
files without native slash-command support. Claude's command files are relative
symlinks to the same definitions, so workflow edits happen in one place.
Codex discovers the `SKILL.md` wrappers in `.agents/skills/`; each wrapper
points to its shared workflow. If the new skills do not appear in the `$`
picker, restart Codex.

Two hooks in `.claude/settings.json` connect Claude to the shared files:

- `UserPromptSubmit` prints `.agents/style-reminder.md` into every prompt.
- `PreToolUse` passes Edit/Write targets through the Claude adapter to
  `.agents/hooks/protect-raw.sh`, blocking writes to existing files under
  `raw/` while allowing new files.

The shared protection script accepts `<repository-root> <target-file>` and
returns exit code 2 when blocked, or 0 when allowed. Relative target paths are
resolved against the repository root. It requires Bash and Python 3.9 or newer.
Other agents need their own hook registration and input adapter to call it.
The included hook covers Claude's Edit/Write tools. Shell writes and deletion
are outside its coverage. Source retraction requires the workflow's approval.
