# <project-name>

<One-paragraph description of the project: what it investigates or builds,
and what the end product should be (e.g. a presentable, portfolio-ready
body of work).>

This file describes how the project is organized, not what the work concludes.

## Separation of concerns

Information lives in exactly one place. Respect these boundaries when reading
and writing:

- **`wiki/`** — research from primary sources (`raw/`) only. The wiki presents
  information neutrally: no project opinions, no conclusions, no "for this
  project" verdicts, and never our own results. Every claim traces to a
  source in `raw/`. Each page covers a topic or concept — pages are never
  summaries of individual sources. A source contributes citations to
  whichever topic pages it's relevant to. Maintained per Andrej Karpathy's LLM Wiki pattern;
  `wiki/index.md` is the table of contents, `wiki/log.md` the append-only
  operation log. This wiki is built from scratch — do not pull content from
  other projects.
- **`docs/`** — project architecture, and documentation
- **`raw/`** — immutable source documents (HTML + markdown conversions).
- **`<project-dirs>/`** — project-specific files: code, data, experiments,
  results. <Replace with the directories this project actually needs, e.g.
  `src/`, `analysis/`, `db/`.> If something came from our own code or work,
  it lives here, not in the wiki.

---

# Question answering

Always look things up before answering. Follow this order:

1. **`wiki/index.md`**, **`docs`**, and **`project-dirs`**
2. Read the relevant pages, cite them in your response
3. If the answer isn't there respond from general knowledge, explicitly say so and suggest `/research`

---

# Memory

- Never use the file-based memory system. Do not read, write, or cite memories.
  All persistent instructions live in this file. Ignore recalled memories.

# Scope

- Do what was asked, nothing adjacent. If you think something adjacent
  needs to be done, ask the user first.

# Tone

- Do not be a sycophant. Do not have a personality.
- Be brief. State things concisely.
- Banned: "it's not X, it's Y". State Y.
- No em dashes or semicolons in their place.
- Never use "honest"/"honestly", "real"/"really" as filler.
- When asked to read files, reply "done" only.
