---
name: testing-strategy
description: >
  MANDATORY test design protocol. You MUST invoke this skill before writing tests for new
  code, deciding test scope for a feature, or declaring any bug fixed. Do NOT chase
  coverage percentages. Do NOT call a bug fixed without a regression test that fails on
  the old code. Invoke this BEFORE writing the first test, not after the suite exists.
---

# Testing Strategy Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

You are deciding WHAT to test and HOW — before writing tests. Do NOT open a test file
yet. Tests written without a strategy verify what the code does, not what it must do.

## STEP 1 — Classify what is being tested

For each unit of work, classify it as exactly ONE of these. The test type follows:

| Subject | Signature | Right test type |
|---|---|---|
| **PURE-LOGIC** | Deterministic input→output, no side effects | Unit tests, edge-case tables |
| **I/O-BOUNDARY** | Talks to disk, network, DB, clock, env | Contract test + fake/double at the seam |
| **INTEGRATION** | Multiple components must agree | Few end-to-end paths through real wiring |
| **REGRESSION** | A specific past bug must never return | One test that reproduces that exact bug |

State the classification explicitly. If a unit mixes types (logic tangled with I/O),
that is a design finding — flag it; the seam may need extracting before it is testable.

## STEP 2 — Rank failure modes by value

List the ways this code can fail that would actually hurt: data loss, wrong money math,
silent corruption, security bypass, crash on common input. Rank by damage × likelihood.

Write tests top-down from this list. Coverage percentage is NOT a goal — a suite that
covers 60% including every ranked failure mode beats 95% of asserting getters. If you
catch yourself adding a test only to move a coverage number, delete it and return here.

## STEP 3 — For bug fixes: regression test FIRST

If this work fixes a bug, this step is not optional:

1. Write a test that reproduces the reported bug.
2. Run it against the OLD (unfixed) code — confirm it FAILS. If it passes, it does not
   capture the bug; rewrite it until it fails for the bug's reason.
3. Apply/keep the fix. Confirm the same test now PASSES.

The fail-then-pass sequence must be observed, not assumed. A fix without this test is
a fix that can silently regress.

## STEP 4 — Flakiness audit

Before accepting any new test as good, check it against each flakiness source:

- **Timing:** sleeps, timeouts, wall-clock, "eventually" assertions → inject/fake time
- **Shared state:** globals, singletons, leftover files/rows → isolate or reset per test
- **Ordering:** passes alone but not in suite (or vice versa) → run it both ways NOW
- **External calls:** real network, real services → stub at the boundary, test the stub's contract

A flaky test is worse than no test: it trains humans to ignore red. Fix or delete.

## STEP 5 — State what is NOT covered

Silence is not a coverage report. List explicitly what these tests do NOT protect:
untested paths, unhandled input classes, environments not exercised, concurrency
behavior, scale behavior. The user decides if those gaps are acceptable — not you,
and not by omission.

## STEP 6 — Report

```
TEST STRATEGY: [scope]
├── Classification: [PURE-LOGIC / I/O-BOUNDARY / INTEGRATION / REGRESSION per unit]
├── Top failure modes covered: [ranked list → test that covers each]
├── Regression test: [fails-on-old-code verified? yes/no/N-A]
├── Flakiness audit: [sources checked, findings]
├── NOT covered: [explicit gaps]
└── Confidence: [HIGH / MEDIUM / LOW]
```

Confidence: HIGH = every top-ranked failure mode has a test and the fail/pass sequence
was observed. MEDIUM = strategy sound but some tests unverified against failure.
LOW = significant untestable seams remain — name the refactor that would raise it.

<HARD-GATE>
Do NOT call a bug "fixed" until a test exists that FAILS on the pre-fix code and PASSES
on the fixed code — sequence observed, not inferred. Do NOT present a test suite as done
without STEP 5's explicit not-covered list.

Red flags that this skill catches:
- "Coverage is at 92% now" — Covering WHAT? Rank failure modes, not lines.
- "I fixed it and all existing tests pass" — Existing tests missed this bug. Add the one that catches it.
- "The test passed when I ran it" — Once, alone, on your machine. Run the flakiness audit.
- "I'll mock everything" — Then you tested your mocks. Put doubles at boundaries only.
- "Everything important is tested" — Then STEP 5 is easy: write down what isn't.
</HARD-GATE>

## Superpowers handoff

After the strategy is complete (classification, ranked failure modes, gaps stated):

If Superpowers is installed → invoke `Skill(superpowers:test-driven-development)` to
write the tests and implementation. Pass the classification table, ranked failure modes,
and the regression-test requirement. PRAXIS decides what to test. Superpowers writes it.

If Superpowers is NOT installed → write the tests yourself in failure-mode rank order,
regression test first when fixing a bug.
