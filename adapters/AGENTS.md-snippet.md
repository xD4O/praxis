# PRAXIS router snippet — for harnesses without skills or hooks

This adapter targets harnesses that consume an `AGENTS.md`, Cursor rules file, or raw
system prompt and have **no skill invocation and no hooks** (Codex CLI, Cursor, generic
AGENTS.md-consuming tools).

It deliberately does **not** contain a copy of the router. The router lives in one
place — `skills/using-praxis/SKILL.md` — and this file is a thin, stable wrapper around
it, so the wrapper never drifts from the source.

## How to generate your AGENTS.md section

Everything below the `PRAXIS-SNIPPET-START` marker in this file is the paste-ready
preamble. Concatenate it with the router body (frontmatter stripped, same `sed` as
`hooks/session-start`) into your target file:

```bash
PRAXIS=/absolute/path/to/praxis   # your PRAXIS checkout
{ sed -n '/^<!-- PRAXIS-SNIPPET-START -->$/,$p' "$PRAXIS/adapters/AGENTS.md-snippet.md" | sed "s|<PRAXIS_DIR>|$PRAXIS|g"
  sed '1{/^---$/!q;};1,/^---$/d' "$PRAXIS/skills/using-praxis/SKILL.md"; } >> AGENTS.md
```

Re-run the command after pulling a new PRAXIS version (delete the old section first).
If you prefer to paste by hand: copy everything below the marker, replace
`<PRAXIS_DIR>` with your checkout path, then paste the body of
`skills/using-praxis/SKILL.md` (without its YAML frontmatter) below this line.

---
<!-- PRAXIS-SNIPPET-START -->
<!-- PRAXIS router (github.com/xD4O/praxis). Do not edit the router body below by
     hand — it is generated from skills/using-praxis/SKILL.md. Edit the source and
     regenerate with adapters/AGENTS.md-snippet.md's command. -->

## PRAXIS reasoning router

The section below is the PRAXIS reasoning router. Follow it for every task.

**Harness adaptation — loading protocols.** This harness has no skill invocation.
Wherever the router says to invoke or load a protocol as a skill, instead read the
protocol file from the PRAXIS checkout and follow it as written:

    <PRAXIS_DIR>/skills/<name>/SKILL.md

If the path above is not an absolute path, the placeholder was never substituted —
ask the integrator for the PRAXIS checkout path before routing.

<!-- paste the body of skills/using-praxis/SKILL.md below this line -->
