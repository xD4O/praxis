# PRAXIS harness adapters

Opt-in integrations that take PRAXIS beyond the happy-path Claude Code plugin
install. Nothing in this directory is registered by the plugin's
`hooks/hooks.json`, and that is deliberate: these adapters change harness
behavior (one of them can block the agent from stopping), so auto-enabling
them for every plugin user would be hostile. You read this file, you decide,
you register them yourself.

## What's here

| File | Harness | What it does |
|---|---|---|
| `AGENTS.md-snippet.md` | Codex CLI, Cursor rules, any AGENTS.md consumer | Paste-ready wrapper that installs the router without skills or hooks |
| `claude-code/user-prompt-submit` | Claude Code (UserPromptSubmit hook) | Deterministic, zero-LLM-cost keyword classifier that injects routing hints |
| `claude-code/stop-gate` | Claude Code (Stop hook) | Deterministic backstop for HARD-GATE invariant 3 (confidence level present) |

## AGENTS.md snippet (harnesses without skills or hooks)

The snippet is a thin wrapper — the router body is never duplicated, it is
generated from `skills/using-praxis/SKILL.md` so it can't drift. Generate your
AGENTS.md section with:

```bash
PRAXIS=/absolute/path/to/praxis   # your PRAXIS checkout
{ sed -n '/^<!-- PRAXIS-SNIPPET-START -->$/,$p' "$PRAXIS/adapters/AGENTS.md-snippet.md" | sed "s|<PRAXIS_DIR>|$PRAXIS|g"
  sed '1{/^---$/!q;};1,/^---$/d' "$PRAXIS/skills/using-praxis/SKILL.md"; } >> AGENTS.md
```

Since such harnesses can't invoke skills, the generated preamble redirects the
router's "Loading a protocol" step to reading
`$PRAXIS/skills/<name>/SKILL.md` directly. See `AGENTS.md-snippet.md` for
details.

## Claude Code hooks

Both hooks are plain bash + python3, no network, no LLM calls, and fail silent
(malformed input → exit 0). Register them in `~/.claude/settings.json` (or a
project's `.claude/settings.json`), replacing the placeholder with your
checkout path:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/absolute/path/to/praxis/adapters/claude-code/user-prompt-submit"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/absolute/path/to/praxis/adapters/claude-code/stop-gate"
          }
        ]
      }
    ]
  }
}
```

Register either hook independently — they don't depend on each other.

### `user-prompt-submit` — classifier nudge

Matches the submitted prompt against high-precision keyword rules mirroring
the router's routing table and prints up to 3 one-line hints to stdout, which
Claude Code injects as additional context ("PRAXIS routing hint: this prompt
matches the '…' row — the … protocol applies."). No match → no output. It
never blocks a prompt (always exit 0).

### `stop-gate` — confidence-level backstop

Deterministic enforcement of HARD-GATE invariant 3: every analysis ends with a
confidence level. When the agent tries to stop, the hook reads the last
assistant message from the transcript; if it is long (>1500 chars), contains
analysis markers (recommend / approach / trade-off / risk), and contains no
confidence marker (`Confidence:`, `HIGH (`, `MEDIUM (`, `LOW (`,
`INSUFFICIENT`), it exits 2 with a one-line stderr reason, which makes the
agent continue and add one.

Loop prevention: when the input JSON has `stop_hook_active: true` (the agent
is already continuing because a Stop hook fired), the hook always exits 0.
One nudge, then it yields — it is a backstop, not a jail.

## Limitations — read before enabling

- **The keyword classifier is high-precision / low-recall by design.** It only
  fires on unambiguous keywords, so most prompts get no hint — that is
  correct behavior. It nudges; the router (already injected at session start)
  decides. Do not treat a missing hint as "no protocol applies", and do not
  widen the regexes until they fire on everything — a noisy hint is worse
  than none. Two router rows (`intent-alignment`, `gap-analysis`) have no
  keyword rule at all: they are ordering rules, not topic matches.
- **The stop-gate heuristic can false-positive** on long non-analysis output
  that happens to mention "recommend" or "risk" (e.g. a long file listing or
  quoted document). That is exactly why it yields after one nudge via
  `stop_hook_active` — worst case is one extra turn where the agent states a
  confidence level or explains why none applies.
- **Deterministic gates on LLM output are blunt.** These adapters are
  backstops for the behavioral enforcement in the skills themselves, not a
  replacement for it. If the router isn't installed, the hints and the gate
  reference protocols the agent has never seen.
- Both hooks require `python3` on PATH; without it they silently no-op.
