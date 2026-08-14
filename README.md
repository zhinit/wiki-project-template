# wiki-project-template

A starter template for projects built around an LLM-maintained wiki,
following Andrej Karpathy's LLM Wiki pattern:
archive primary sources immutably, have the agent distill them into an
interlinked wiki of concept pages, and keep your own conclusions and results
strictly separate from the research.

Designed for use with [Claude Code](https://claude.com/claude-code).

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

The wiki is the agent's knowledge base. When you ask factual questions, it
answers from the wiki and cites pages — never from general knowledge. If the
wiki doesn't cover it, it says so.

Original work is still welcome. Every claim has one of three statuses:
**established** (in the wiki, cited), **verified** (our own result, actually
checked — code run, experiment executed, proof checked), or **conjecture**
(everything else, including brainstorms from the model's general knowledge).
Conjectures are allowed and labeled; they're promoted by verifying them or by
sourcing them via `/research`, and they never enter the wiki.

## Getting started

1. Clone or copy this template into a new project directory.
2. Edit `CLAUDE.md`: fill in the project name, the one-paragraph description,
   and replace `<project-dirs>` with the directories your project needs
   (e.g. `src/`, `analysis/`, `db/`).
3. Start Claude Code and run `/research <your first topic>`.

## Commands

- **`/research <topic>`** — searches the web and arXiv for primary sources,
  presents candidates for approval, archives them to `raw/`, and ingests them
  into the wiki as summary and concept pages. A single source may touch 10–15
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
CLAUDE.md                      -- project rules: separation of concerns,
                                  page format, question-answering order, tone
wiki/                          -- index.md and log.md, empty to start
raw/                           -- html/ and md/, empty to start
docs/                          -- empty to start
.claude/
  commands/research.md         -- /research command
  commands/lint_wiki.md        -- /lint_wiki command
  commands/retract_source.md   -- /retract_source command
  settings.json                -- hooks (rule re-injection, raw/ protection)
  style-reminder.md            -- the condensed rules the hook injects
  hooks/protect-raw.sh         -- blocks edits to existing files in raw/
```

Two hooks in `.claude/settings.json` enforce the rules mechanically:

- `UserPromptSubmit` prints `style-reminder.md` into every prompt, so the
  core rules (write to one place, cite everything, never answer from general
  knowledge) survive long sessions where the agent might otherwise drift.
- `PreToolUse` blocks Edit/Write on existing files under `raw/`, making
  immutability enforced rather than advisory. Creating new source files
  still works; removing one goes through `/retract_source`.
