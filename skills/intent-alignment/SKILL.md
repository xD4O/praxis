---
name: intent-alignment
description: >
  MANDATORY convergence step. You MUST invoke this skill FIRST — before
  problem-classification — whenever a non-trivial request's scope or goal could
  plausibly be read more than one way. Do NOT start substantive work on your own
  reading of an ambiguous request. Do NOT assume the most reasonable interpretation
  is the user's. Trivial, unambiguous requests skip this per the using-praxis
  complexity gate: typo fixes, renames, one-liners, factual questions, running commands.
---

# Intent Alignment Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each step in order.

This is the Converge half of PRAXIS: make sure you and the user mean the same thing
BEFORE any classification, design, or code. Misreading the request is the cheapest
failure to prevent and the most expensive to discover after delivery.

## STEP 0 — Applicability check

Answer both, explicitly:
1. Is this non-trivial under the using-praxis complexity gate?
2. Could the request's scope or goal plausibly be read more than one way?

Both YES → run STEPS 1–3. Either NO → state "intent-alignment: skipped, request is
[trivial | unambiguous]" and proceed to `problem-classification`. Do not answer NO to
question 2 without completing the 10-second version of STEP 1 first — "obviously
unambiguous" is a conclusion, not an observation.

## STEP 1 — Three-interpretations check

Internally, generate at least 3 plausible interpretations of what "done" looks like
for this request. For each, write one line: what would be delivered and to what scope.
Vary them along real axes: breadth (one file vs the system), depth (quick fix vs
redesign), target (the symptom named vs the cause behind it), audience (for the user
vs for their users).

Then answer: would these interpretations produce meaningfully different work?
- **CONVERGE** — all interpretations yield substantially the same output. Note this.
- **DIVERGE** — the divergence IS your clarifying question. Never ask a generic
  "can you clarify?" — present the concrete options: "This could mean (a) X,
  (b) Y, or (c) Z — which one?"

## STEP 2 — Misunderstanding premortem

Assume you completed the work, handed it back, and the user said "that's not what
I meant." Work backward: what is the single most likely misunderstanding that
produced that reaction? (Same inversion technique as gap-analysis CHECK 1, applied
to your reading of the request instead of a finished design.)

State it in one line: "Most likely misread: [X]." Then decide:
- If that misread would waste significant work or is hard to undo → it goes into
  the STEP 3 mirror as an explicit question.
- If it is cheap to correct later and low-probability → it goes into the STEP 3
  mirror as a stated assumption.

## STEP 3 — Spec mirroring

Restate the request to the user in your own words — not a paraphrase of their
sentence, a reconstruction of their intent. Use exactly this format:

```
SPEC MIRROR
My understanding: [1–2 sentences, your words]
In scope:       [what you will do, explicitly]
Out of scope:   [what you will NOT do, explicitly]
Assuming:       [everything you inferred that the user did not say]
Open question:  [the STEP 1 divergence and/or STEP 2 misread, as concrete options
                 — or "none"]
Convergence confidence: [HIGH / MEDIUM / LOW per the using-praxis scale]
```

Present this to the user and wait for confirmation. Do not treat your own mirror
as self-confirming — the point is that the USER validates it, not that you wrote it.

<HARD-GATE>
Do NOT proceed to problem-classification, design, planning, or code on an ambiguous
request until ONE of these holds:
- The user has confirmed the spec mirror (corrections incorporated), OR
- No user is available to confirm — apply the using-praxis "Autonomous mode" section
  as written: state the interpretation you are choosing and its concrete risk in
  writing, cap confidence at MEDIUM, proceed, and surface the open questions at the
  end of your output. Do not redefine autonomous mode here; that section governs.

Red flags that this skill catches — the exact thoughts that precede skipping it:
- "The request seems clear enough" — clear to you is not confirmed by them. Run STEP 1;
  it costs one minute.
- "Asking would slow things down" — one question now is cheaper than one rebuild later.
- "I'll just build the most reasonable version" — most reasonable to whom? That is an
  unconfirmed interpretation wearing a confident face.
- "They'll correct me if I'm wrong" — after you've spent the work, at full price.
- "I already know what they want from context" — then the mirror takes 30 seconds and
  confirms it. Write it anyway.
</HARD-GATE>

## Superpowers handoff

After the spec mirror is confirmed (or the autonomous-mode fallback is applied):

If Superpowers is installed → do NOT hand off from here. Proceed to
`problem-classification` first — it owns the handoff to `superpowers:brainstorming`.
Pass the confirmed spec mirror (scope, exclusions, assumptions, resolved questions)
forward as context so it arrives in brainstorming intact. PRAXIS converged; now
PRAXIS classifies.

If Superpowers is NOT installed → proceed to `problem-classification` with the
confirmed spec mirror as its input framing. You are the only reasoning layer available.
