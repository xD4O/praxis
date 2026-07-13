---
name: codebase-comprehension
description: >
  MANDATORY comprehension protocol. You MUST invoke this skill before changing code you did
  not write or do not already understand — modifying, fixing, extending, or refactoring an
  existing file, function, or module whose behavior you have not traced. Do NOT edit from
  pattern-matching. Do NOT claim "nothing else is affected" without checking. Invoke BEFORE
  proposing the edit. Does NOT apply to greenfield code you are writing from scratch, or to
  diagnosing a runtime failure (use diagnostic-reasoning).
---

# Codebase Comprehension Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

The expensive bugs are not in the line you change — they are in the caller three files away
that depended on the behavior you just changed. This protocol forces you to map the blast
radius before you touch anything.

## STEP 1 — Locate entry points and the change site

Identify how execution reaches the code you intend to change: who calls it, from where, and
under what conditions. If you cannot say how the code is reached, you cannot predict what
your change affects.

## STEP 2 — Trace the data flow through the change site

Follow the actual values through the code you will touch: what comes in, what is read or
mutated, what goes out, and in what units/shape/type. State it explicitly — do not assume the
values are what the names suggest.

## STEP 3 — Enumerate every consumer of what you will change

List everything that depends on the current behavior or shape: callers, subscribers, tests,
serialized formats, anything downstream. This set IS the blast radius. "It's just a small
change" is a claim about this list — so produce the list.

## STEP 4 — Name at least one thing that could break elsewhere

From the blast radius, state a concrete failure the change could cause OUTSIDE the code you
are editing — a specific caller that passes values differently, a consumer relying on the old
shape. "Nothing else is affected" is allowed only after STEP 3 produced an empty consumer set
and you say so.

## STEP 5 — Report

```
COMPREHENSION: [code to change]
├── Entry points: [how execution reaches it]
├── Data flow: [in → transform → out, with shapes/units]
├── Blast radius: [every consumer of current behavior/shape]
├── At-risk elsewhere: [≥1 concrete off-site failure the change could cause]
└── Confidence: [HIGH / MEDIUM / LOW]
```

Confidence: **HIGH** — full call graph and data flow traced, blast radius complete.
**MEDIUM** — main paths traced, some dynamic/indirect callers unverified. **LOW** — the code
is reached by paths you cannot fully see; widen the trace before editing.

<HARD-GATE>
Do NOT propose an edit until:
- The entry points reaching the change site are named
- The data flow through the change site is traced with shapes/units, not assumed
- Every consumer of the current behavior/shape is listed (the blast radius)
- At least one concrete off-site risk is named — or the consumer set is verified empty

Proposing an edit to unfamiliar code with no blast-radius trace is a protocol violation, even
if the change "obviously just does one thing".

Red flags that this skill catches:
- "It's a one-line change, it's safe" — one-line changes to shared code have the widest blast
  radius precisely because they look safe. List the callers.
- "The function name tells me what it does" — names lie, especially in old code. Trace the
  values.
- "I'll find the breakage when tests fail" — if the consumer has no test, the breakage ships.
  Find the consumers first.
- "Nothing else uses this" — a claim, not a fact, until STEP 3 is done. Do STEP 3.
</HARD-GATE>

## Handoff

Once the blast radius is mapped, make the edit, then verify each at-risk consumer. If the
trace reveals a failing behavior, hand off to `diagnostic-reasoning`; if it reveals a
structural problem, to `architecture-reasoning`.
