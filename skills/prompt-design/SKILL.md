---
name: prompt-design
description: >
  MANDATORY prompt-design protocol. You MUST invoke this skill when writing or revising a
  prompt, system prompt, agent instruction, or LLM task specification meant to run
  repeatedly — "write a prompt that...", "improve this prompt", "the model keeps doing X, fix
  the instructions". Do NOT ship a prompt tested only on the happy path. Do NOT finalize
  before adversarial inputs are run against it. Invoke BEFORE handing over the prompt. Does NOT
  apply to a one-off question you are asking a model right now, or to ordinary application code.
---

# Prompt Design Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

A prompt is a program with a fuzzy interpreter. It will meet inputs you did not imagine, and
the failures surface in production where you cannot see them. This protocol makes the prompt
fail in front of you first.

## STEP 1 — Write the task spec

State exactly what the prompt must make the model do: the inputs it receives, the required
output shape, and the ONE behavior that defines success. If you cannot state success in one
checkable sentence, the prompt has no target to hit.

## STEP 2 — Enumerate concrete failure modes

List the specific ways THIS prompt will go wrong — not "might be inaccurate". Name the modes:
missing/empty input, multiple valid answers, adversarial/injection input, format drift,
over-refusal, under-refusal, hallucinated fields, non-target language. A generic risk list
fails this step.

## STEP 3 — Design adversarial test inputs

Write at least 3 concrete inputs chosen to TRIGGER the STEP 2 failure modes — the empty one,
the malicious one, the ambiguous one. Happy-path examples do not count; each input must aim
at a specific failure mode.

## STEP 4 — Predict behavior on each, then revise

For each adversarial input, state what the current prompt would produce and whether that is
acceptable (PASS/FAIL). For every FAIL, revise the prompt and say exactly what wording changed
and which failure mode it closes. A prompt with no revisions after an adversarial pass either
had them fixed already (show it) or was not pressure-tested.

## STEP 5 — Report

```
PROMPT DESIGN: [purpose]
├── Task spec: [inputs, output shape, one-sentence success condition]
├── Failure modes: [named, specific to this prompt]
├── Adversarial tests: [input → predicted behavior → PASS/FAIL, ≥3]
├── Revisions: [what changed and which failure mode it closes]
└── Confidence: [HIGH / MEDIUM / LOW]
```

Confidence: **HIGH** — every named failure mode has an adversarial test that now passes.
**MEDIUM** — main failure modes covered, some hard to test without live runs. **LOW** —
failure modes named but untested, or a FAIL remains open; do not ship yet.

<HARD-GATE>
Do NOT finalize or hand over the prompt until:
- The task spec states inputs, output shape, and a one-sentence success condition
- At least 3 named failure modes are listed, specific to this prompt
- At least 3 adversarial inputs were run, each with a predicted behavior and PASS/FAIL
- Every FAIL was fed back into a named revision, or is flagged as a known open risk

Delivering a prompt tested only on the happy path is a protocol violation, even if it "looks
like it works".

Red flags that this skill catches:
- "The prompt is clear, it'll be fine" — clear to you, ambiguous to the input you did not
  picture. Run the adversarial three.
- "Edge cases are rare" — at scale, rare is hourly. Name three and test them.
- "I'll add guardrails if it misbehaves" — you will not see it misbehave; it fails silently in
  someone else's output. Provoke the failure now.
- "Testing prompts is hand-wavy" — predicting behavior on a named malicious input is not
  hand-wavy; skipping it is.
</HARD-GATE>

## Handoff

Once the prompt passes its adversarial set, ship it with the test inputs kept as regression
examples. If it drives an agent or tool call, run `security-reasoning` on the trust boundary
the prompt sits on.
