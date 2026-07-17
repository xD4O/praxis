# PRAXIS regression evals

Headless behavioral tests for the claims made by `skills/using-praxis/SKILL.md`
(the router): the complexity gate, depth tiers, compositional routing, the
HARD-GATE invariants, informed-consent override, autonomous mode, and the
anti-theater check. Previously these were verified by a human typing prompts
from a manual test plan into live sessions; this harness automates that loop.

Each case sends a prompt to `claude -p` with **this working tree's** router
appended to the system prompt (built by running `hooks/session-start`, so you
test the checkout, not the installed plugin), then grades the transcript with
a second `claude -p` judge call against the case's rubric, which must return a
strict JSON verdict.

## Running

```sh
cd evals
./run.sh                 # all cases (T2.1–T2.27, sequential)
./run.sh T2.4            # one case
./run.sh T2.1 T2.9       # a subset
./run.sh --list          # print case IDs and titles, no model calls
./run.sh --model sonnet  # pass a model to subject + judge (default: claude's default)
```

Exit code 0 means every graded case passed; 1 means at least one FAIL or ERROR.
Per-run artifacts (router snapshot, prompts, transcripts, judge output, parsed
verdicts) land in `evals/results/<timestamp>/<case-id>/`.

Requirements: `claude` CLI on PATH (logged in), `python3`, bash. Each case costs
two real model calls (subject + judge).

## Adding a case

Create `cases/T<n>.md`. Case files are pure data — all logic lives in `run.sh`:

```markdown
# T2.11 — short name: one-line statement of the claim under test

Free-form context (ignored by the runner).

## Prompt
The exact prompt sent to the subject agent.

## Rubric
1. Concrete, checkable criterion.
2. Another one. Write criteria the judge can verify from the transcript alone.

## Skills
skill-name-to-pre-load
```

`## Skills` is optional: each listed skill's body (frontmatter stripped) is
pre-loaded into the subject's system prompt. Use it when the rubric tests
behavior mandated by a sub-skill (e.g. gap-analysis's 7 checks) rather than by
the router text itself — it mirrors an install where routing actually loads
the skill. Omit it when the claim under test is the router's own behavior.

Good criteria are observable ("states a confidence level of MEDIUM or lower"),
not vibes ("is thoughtful"). Include an anti-theater criterion when the claim
is about substance: the judge is instructed that template-filling fails.

## Honest caveats

- **LLM-judged evals are noisy.** A single FAIL is a signal to open the
  transcript in `evals/results/` and read it — not proof of a regression. Rerun
  the case before concluding anything; treat repeated FAILs as real.
- The judge is instructed to default to FAIL when uncertain, so expect some
  false negatives on borderline transcripts (especially T2.5's line counts and
  T2.7's anti-theater judgment).
- The subject runs with **all tools disabled** (`--tools ""`,
  `--disable-slash-commands`) and is told so in its system prompt — without
  that notice, subjects attempt a doomed skill-file Read that terminates the
  headless turn before the router's inline fallback can fire, an artifact no
  real harness has (real harnesses return tool errors and the agent recovers).
  What's graded is the behavior the injected text induces: router only by
  default, router + named sub-skills for cases with a `## Skills` section.
  These evals still do not exercise the plugin's actual skill-invocation path.
- Hooks, user MCP servers, and project CLAUDE.md discovery are disabled or
  avoided for the eval calls, but user-level memory that `claude` injects on
  its own may still be in context on your machine.
- Results are model-dependent. Compare runs against the same `--model`.
- `evals/results/` is gitignored; transcripts can contain whatever the models
  produced. Don't commit them.
