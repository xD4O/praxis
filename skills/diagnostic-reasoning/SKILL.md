---
name: diagnostic-reasoning
description: >
  MANDATORY debugging protocol. You MUST invoke this skill when debugging complex issues,
  investigating failures, diagnosing intermittent problems, or performing root cause
  analysis. Do NOT start changing code before collecting observations. Do NOT guess at
  causes — generate 5 competing hypotheses and design a discriminating test. Invoke this
  BEFORE touching any code when something is broken.
---

# Diagnostic Reasoning Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

Something is broken. Do NOT start changing code. Follow this protocol.

## PHASE 1 — Observe precisely

Before forming any hypothesis, collect facts. Answer each:

- **What exactly happened?** (exact error, exact behavior, exact output)
- **When did it start?** (timestamp, deploy, config change, load change)
- **How often?** (every time, intermittent, under specific conditions)
- **What changed recently?** (deploys, config, dependencies, traffic patterns)
- **What's the blast radius?** (all users, some users, one endpoint, one region)

Do NOT proceed until you can state the problem in one precise sentence that
another engineer could verify independently.

## PHASE 2 — Generate competing hypotheses

Produce at least 5 hypotheses. Fewer and you are anchored on your first guess rather
than diagnosing. Add more if the observations genuinely suggest them; stop when new
candidates are restatements of ones you already have, not at a count.

For each hypothesis, state:
- What it would explain
- What it would NOT explain (if anything in the observations contradicts it)
- Prior probability estimate (likely / possible / unlikely)

Order by: (explanatory power) × (prior probability), highest first.

**Mandatory check:** Is your #1 hypothesis the simplest explanation?
Simple causes first: config error, permissions, missing dependency, wrong
environment, typo. Check these before investigating race conditions,
memory corruption, or kernel bugs.

## PHASE 3 — Design a discriminating test

Do NOT test hypotheses one by one. Design a single observation that
distinguishes between your top 3 hypotheses simultaneously.

Template: "If I observe [X], then hypothesis A is supported.
If I observe [Y], then hypothesis B is supported.
If I observe [Z], then hypothesis C is supported."

This is Strong Inference. One test, maximum information.

If no single test distinguishes all three, design the test that eliminates
the most hypotheses regardless of outcome (maximum information gain).

## PHASE 4 — Execute and update

Run the test. Observe the result.

- Which hypotheses are eliminated?
- Which are supported?
- Does the result suggest a NEW hypothesis not in your original list?

Update your hypothesis ranking. If the top hypothesis is now >80% likely,
proceed to verification. If not, return to Phase 3 with the surviving
hypotheses.

## PHASE 5 — Root cause drilling

You found WHAT is broken. Now find WHY.

Ask "Why?" five times minimum:

1. Why did [the immediate failure] happen?
2. Why did [the cause from #1] happen?
3. Why did [the cause from #2] happen?
4. Why did [the cause from #3] happen?
5. Why did [the cause from #4] happen?

Stop when you reach a systemic cause (process, tooling, policy) rather than
an individual cause (person made a mistake). Fix the systemic cause.

## PHASE 6 — Verify the fix

After applying the fix:
- Does the original symptom disappear?
- Does the discriminating test from Phase 3 now show healthy behavior?
- Are there related symptoms that should also be checked?
- What prevents this from recurring? (monitoring, test, guard, policy)

<HARD-GATE>
Do NOT declare an issue fixed until:
- Root cause is identified (not just the symptom patched)
- Fix is verified against original observation
- Recurrence prevention is in place or documented as needed

Red flags that this skill catches:
- "I think it might be..." — Generate 5 hypotheses, not 1 guess.
- Changing code before collecting observations — Observe first. Always.
- Testing hypotheses sequentially — Use Strong Inference to test simultaneously.
- "Fixed!" after patching the symptom — Did you drill to root cause?
- "Can't reproduce" — That's an observation, not a conclusion. What conditions differ?
</HARD-GATE>

## Superpowers handoff

After root cause is identified and fix is designed:

If Superpowers is installed → invoke `Skill(superpowers:systematic-debugging)` or
`Skill(superpowers:test-driven-development)` to implement the fix. Pass your ranked
hypotheses, discriminating test results, and root cause analysis. The fix should be
implemented via TDD: write a test that reproduces the root cause, verify it fails,
then fix. Do NOT write the fix inside this skill. PRAXIS diagnosed. Superpowers fixes.

If Superpowers is NOT installed → implement the fix yourself, following TDD principles
where possible.
