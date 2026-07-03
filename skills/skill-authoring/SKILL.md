---
name: skill-authoring
description: >
  MANDATORY authoring protocol. You MUST invoke this skill when creating a new agent
  skill (a SKILL.md behavioral protocol) or substantially rewriting one — for any
  repo or harness that consumes the Agent Skills format. Do NOT write a skill as a
  reference document. Do NOT publish a skill whose trigger description was never
  tested against prompts that should NOT fire it. Does NOT apply to ordinary code,
  docs, prompts, or config — only to authoring skills themselves.
---

# Skill Authoring Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each step in order.

You are creating a skill — a behavioral protocol another agent will be trusted to
follow. A weak skill is worse than no skill: it burns context, triggers on the wrong
tasks, and trains users to ignore the ones that matter. Build it in this order.

## STEP 1 — Name the gap

State in one sentence the specific reasoning failure this skill prevents, and cite a
concrete incident where an agent without it went wrong. If no incident exists — yours,
the user's, or a documented pattern — say so and ask whether the skill should exist at
all. A skill nobody has failed without is a reference document waiting to happen.

## STEP 2 — Design the trigger before the body

The frontmatter `description` is the enforcement layer: it is the ONLY part loaded at
all times — the body loads after invocation, so a vague description means the body
never runs. Write the description as a trigger, then test it:

1. List the task shapes where this skill MUST fire, concretely.
2. List adjacent task shapes where it must NOT fire (the false-positive set).
3. Write at least 3 prompts that should trigger it and 3 that should not, and check
   the description text ALONE classifies all of them correctly. Fix the wording, not
   the test set, until it does.

Use imperative mandatory voice ("You MUST invoke... Do NOT...") — passive descriptions
("useful for...") measurably under-trigger.

## STEP 3 — Design the protocol body

Every step must be an imperative action ending in a check the agent can fail — "Do X;
if Y, stop" — never "consider X." Apply the earn-its-place test: if deleting a step
would not change the agent's output on the STEP 2 trigger prompts, delete it. More
steps is dilution, not rigor.

Then choose exactly ONE `<HARD-GATE>`: the single thing this skill refuses to let
happen, stated as an observable condition ("do NOT claim the bug fixed without a test
observed failing pre-fix"), not a mood ("be thorough"). Add a structured output block
so results are auditable, and confidence levels if the skill produces an analysis.
Keep the whole file under 150 lines — past that, it is doing two jobs; split it.

## STEP 4 — Write red flags from real rationalizations

List the exact thoughts an agent has in the moment before it skips this skill — from
the STEP 1 incident, observed sessions, or your own reasoning while writing STEPS 1–3
(if you caught yourself thinking "this step is probably optional," that IS a red
flag). Each entry is a quoted thought plus the one-line rebuttal. Generic warnings
("be careful," "don't rush") are filler and fail this step.

## STEP 5 — Pressure-test before shipping

Run both, and show the transcripts or walkthroughs:

1. **Realistic case:** walk one representative task through the protocol end-to-end.
   It must produce visibly different (better) behavior than the no-skill baseline —
   if the output is what the agent would have done anyway, the skill adds ceremony,
   not value.
2. **Adversarial case:** construct an input where the HARD-GATE should refuse, and
   confirm it refuses. A gate that never blocks anything in testing is not a gate.

If the harness supports headless runs, encode both as regression cases (see `evals/`
in PRAXIS for the pattern) so the claim stays tested after you're gone.

## STEP 6 — Ship checklist

Before committing: the file is under 150 lines; this change is one skill (no bundled
extras); you searched for an existing skill covering the same gap; and a human has
seen the complete file — not a summary — and approved it.

```
SKILL AUTHORED: [name]
├── Gap: [failure prevented — incident cited or absence flagged]
├── Trigger: [fires on X, silent on Y — 6/6 classification prompts passed]
├── HARD-GATE blocks: [the observable condition]
├── Red flags: [N, each a real rationalization with rebuttal]
├── Pressure-test: [realistic case improved baseline; adversarial case BLOCKED]
└── Confidence: [HIGH / MEDIUM / LOW — LOW if either pressure-test was skipped]
```

<HARD-GATE>
Do NOT publish, commit, or hand over a new or rewritten skill until:
- The gap is named with an incident (or its absence is flagged to the user)
- The description alone correctly classified all STEP 2 trigger AND non-trigger prompts
- The adversarial pressure-test showed the HARD-GATE actually refusing
- Every red flag quotes a specific rationalization, not a generic caution

Red flags that this skill catches:
- "The skill is obviously useful, I don't need an incident" — no incident means no
  test for whether it works. Find one or flag it.
- "The description can be short, the body explains everything" — the body is invisible
  until the description fires. A skill with a weak trigger is a file, not a behavior.
- "I'll pressure-test it after shipping" — after shipping, the failing agent is the
  test, at the user's expense.
- "More steps make it more rigorous" — every step that doesn't change output dilutes
  the ones that do.
- "This reference material is close enough to a protocol" — a list of things to know
  is not a sequence of actions with checks. Rewrite it or don't ship it.
</HARD-GATE>
