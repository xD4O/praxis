---
name: estimation
description: >
  MANDATORY estimation protocol. You MUST invoke this skill before quoting effort, time,
  or cost for any non-trivial work — project plans, "how long will this take", migration
  sizing, budget requests. Do NOT give a single-point estimate. Do NOT estimate from
  first-principles optimism when comparable work exists to anchor on. Invoke this BEFORE
  committing to any plan with a number attached.
---

# Estimation Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

You are about to attach a number to future work. Unexamined estimates are optimism with
a unit. Follow this protocol before any number reaches the user.

## STEP 1 — Decompose until estimable

Break the work into pieces. Apply the test to EACH piece: "Can I state a bounded
estimate for this piece and say why?" If you cannot, it is not broken down enough —
split it again. Repeat until every leaf piece passes.

A piece that resists decomposition ("integrate with their API... somehow") is not an
estimation problem, it is an unknown. Move it to STEP 3's unknowns list and, if it
dominates the total, recommend a timeboxed spike BEFORE estimating the rest.

## STEP 2 — Reference-class forecast each piece

For each piece, ask in order: Has this agent done comparable work this session? In
this codebase? Is there a well-known reference class (e.g., "CRUD endpoint", "schema
migration", "OAuth integration")?

- If YES → anchor on what that comparable work ACTUALLY took, not what it should have
  taken. Mark the piece **REF-BACKED**.
- If NO → estimate from structure, then mark the piece **GUESSED** and double its range
  width. Do not silently treat a guess like a reference.

Tally the counts: N pieces REF-BACKED, M pieces GUESSED. You will need this in STEP 5.

## STEP 3 — Produce a range, never a point

For the total, state LOW and HIGH bounds, not one number. Then name the SPECIFIC
unknowns that widen the range — each unknown must be a noun you could investigate
("their API's rate-limit behavior"), not a vibe ("some risk").

If asked for a single number anyway, give the range and say which bound you would
commit to and why. Never collapse the range silently.

## STEP 4 — Planning-fallacy check

Ask explicitly: "What is usually forgotten in estimates like this?" Check each:

- **Integration:** pieces that work alone but must be wired together
- **Edge cases:** error paths, empty states, retries, permissions
- **Review cycles:** feedback, rework, approval latency
- **Environment:** setup, credentials, CI, deploy friction
- **Unknown unknowns:** things this list itself misses

For each that applies, ADD it to the estimate as a named line item with its own range.
Do not "hope it fits in the buffer" — an unnamed buffer is the first thing negotiated
away. If nothing on this list applies, state why — that claim is itself suspect.

## STEP 5 — Report

```
ESTIMATE: [work]
├── Range: [LOW] – [HIGH] [unit]
├── Breakdown: [piece → range → REF-BACKED or GUESSED, one line each]
├── Reference classes used: [what comparable work anchored which pieces]
├── Key unknowns widening the range: [specific, investigable items]
├── Planning-fallacy additions: [named line items from STEP 4]
└── Confidence: [HIGH / MEDIUM / LOW]
```

Confidence is TIED to the STEP 2 tally:
- **HIGH** — most pieces REF-BACKED; unknowns named and small relative to total.
- **MEDIUM** — mixed REF-BACKED and GUESSED; range honestly wide.
- **LOW** — mostly GUESSED or one unknown dominates; recommend a spike to convert
  the biggest GUESSED piece to REF-BACKED before anyone commits to this number.

<HARD-GATE>
Do NOT present any estimate until:
- Every piece passed the "can I bound it?" decomposition test, or is a named unknown
- The estimate is a RANGE with at least one specific unknown named as widening it
- The planning-fallacy checklist was run and its additions appear as named line items
- Confidence is stated and matches the REF-BACKED vs GUESSED tally

A single-point estimate with no range and no named uncertainty is a protocol
violation, even if the user asked for "just a number."

Red flags that this skill catches:
- "Roughly 2 days" — Roughly means a range exists in your head. Write it down.
- "This should be simple" — "Should be" is the planning fallacy speaking. Run STEP 4.
- "Best case, about..." — Best case is the LOW bound. Where is the HIGH bound?
- Estimating a piece you couldn't describe — decompose or spike, don't number a fog.
- Padding 20% "for safety" — Unnamed padding hides which risk it covers. Name it.
</HARD-GATE>

## Superpowers handoff

After the estimate is presented and the user accepts a bound to plan against:

If Superpowers is installed → invoke `Skill(superpowers:writing-plans)` with the
breakdown, ranges, and named unknowns as input — each GUESSED piece should surface in
the plan as an early de-risking task. PRAXIS estimates. Superpowers plans.

If Superpowers is NOT installed → write the plan yourself, sequencing the biggest
unknowns first so the estimate can be corrected earliest.
