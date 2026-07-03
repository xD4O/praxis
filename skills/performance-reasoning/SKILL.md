---
name: performance-reasoning
description: >
  MANDATORY optimization protocol. You MUST invoke this skill when something works but
  needs to be faster, cheaper, or smaller — latency reduction, cost cuts, memory limits,
  throughput targets. Do NOT change code before capturing a baseline measurement that
  names the actual bottleneck. Do NOT optimize a guessed hot spot. Invoke this BEFORE
  touching any code on an OPTIMIZE problem.
---

# Performance Reasoning Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

Something works but needs to be better. Do NOT start optimizing. An unmeasured
optimization is a guess wearing a lab coat. Follow this protocol.

## STEP 1 — Measure the baseline

Before changing anything, produce a baseline measurement:

- **Metric:** the exact number the user wants improved (p95 latency, $/month, RSS, req/s)
- **Method:** the exact command, profiler, or benchmark used — record it verbatim
- **Result:** the current value, plus variance across at least 3 runs
- **Bottleneck:** the specific function, query, or resource the profile names as dominant

Do NOT proceed on intuition ("it's probably the DB"). If you cannot run a profiler or
benchmark, add measurement instrumentation FIRST — that is the first task, not optional.

## STEP 2 — Identify the single binding constraint

Apply Theory of Constraints. From the baseline profile, name exactly ONE binding
constraint — the resource or step that limits the whole system. Not a list of
"things that could be slow." One.

State it as: "The constraint is [X], consuming [N]% of [metric]. Improving anything
else changes the end-to-end number by at most [100−N]%."

If no single item dominates (nothing above ~30%), say so explicitly — that is a
finding, and it means broad rewrites, not spot fixes, and the user must confirm scope.

## STEP 3 — Premature-optimization check

Before designing a fix, answer each:

- Is this constraint on the critical path the user actually cares about?
- Does the current value violate a stated requirement, or just look improvable?
- What is the cost of NOT optimizing? (Amdahl check: max possible end-to-end gain)
- Is the code that hosts the constraint about to be replaced anyway?

If the honest answer is "this doesn't matter yet," STOP and report that back with the
baseline numbers as evidence. Recommending no change is a valid, complete outcome.

## STEP 4 — Optimize the constraint only

Design the smallest change that attacks the named constraint (Pareto: the 20% of code
causing 80% of the cost). Do not bundle unrelated "while I'm here" improvements — they
contaminate the measurement. One constraint, one change, one measurement.

## STEP 5 — Verify with the SAME measurement

Re-run the EXACT method recorded in STEP 1 — same command, same load, same environment,
same run count. Do not substitute a different benchmark that flatters the change.

Confirm: the metric improved AND the profile shows the old bottleneck no longer
dominates (the constraint moved). If the number improved but the profile is unchanged,
you measured noise — investigate before claiming success.

## STEP 6 — Report with trade-offs

```
OPTIMIZATION RESULT: [what changed]
├── Baseline: [value] measured by [method]
├── After:    [value] measured by [same method]
├── Constraint: [old bottleneck] → [new bottleneck, there is always one]
├── Trade-off: [what got worse — memory, complexity, cold-start, cost. "None" is suspect]
├── Regression check: [tests/behavior verified unchanged]
└── Confidence: [HIGH / MEDIUM / LOW]
```

Confidence: HIGH = same-method before/after with stable variance and moved constraint.
MEDIUM = improvement measured but variance overlaps or environment differed.
LOW = could not reproduce baseline conditions — say what measurement would raise it.

<HARD-GATE>
Do NOT claim a performance fix is done until:
- A baseline exists from STEP 1 naming the bottleneck via a recorded method
- The after-measurement uses the SAME method, environment, and load as the baseline
- The trade-off (what got worse) is stated explicitly — every optimization spends something

Red flags that this skill catches:
- "This is obviously the slow part" — Profile it. Obvious suspects are wrong constantly.
- "I optimized the loop, it should be faster now" — "Should be" is not a measurement.
- "The micro-benchmark shows 10x" — Against the STEP 1 method, or a friendlier one?
- "No downside" — You traded memory, readability, or generality. Name it.
- Optimizing before anyone asked for a target — run STEP 3, it may not matter yet.
</HARD-GATE>

## Superpowers handoff

After the constraint is identified and the fix is designed (end of STEP 4):

If Superpowers is installed → invoke `Skill(superpowers:test-driven-development)` to
implement the change. Pass the baseline numbers, the named constraint, and the exact
measurement method — the before/after verification in STEP 5 still belongs to this
protocol. PRAXIS measures and targets. Superpowers implements.

If Superpowers is NOT installed → implement the change yourself, then return to STEP 5.
