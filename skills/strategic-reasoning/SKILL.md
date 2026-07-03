---
name: strategic-reasoning
description: >
  MANDATORY strategic analysis. You MUST invoke this skill for business decisions, product
  strategy, competitive analysis, roadmap prioritization, or any decision about WHAT to
  build rather than HOW to build it. Do NOT skip SWOT analysis. Do NOT present strategy
  without measurable OKRs. Invoke when the problem is about direction, positioning, or
  priorities rather than implementation.
---

# Strategic Reasoning Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

This isn't a code problem — it's a strategy problem. Different tools.

## STEP 1 — Clarify the real job

Ask: "What job is the user actually hiring this solution for?"

The stated goal is often not the real goal:
- "We need a dashboard" → Real job: "Convince the board we're growing"
- "Add feature X" → Real job: "Stop losing customers to competitor Y"
- "Rewrite in Rust" → Real job: "Our system can't handle next year's scale"

State the real job in one sentence. Confirm with the user.

## STEP 2 — Situational assessment (SWOT)

Complete all four quadrants. Each must have 3+ items.

- **Strengths** (internal, positive): What advantages exist today?
- **Weaknesses** (internal, negative): What limitations constrain you?
- **Opportunities** (external, positive): What trends or gaps can you exploit?
- **Threats** (external, negative): What could undermine you?

Then cross-reference:
- How can strengths capture opportunities?
- How do weaknesses amplify threats?
- Which Strength+Opportunity pair is the highest-leverage play?

## STEP 3 — Competitive landscape

If competitors or alternatives are relevant, map them:

- Who else solves this job? (direct competitors, substitutes, "do nothing")
- What do they do better? What do they do worse?
- Where is the uncontested space they don't occupy?

State the differentiation strategy in one sentence.

## STEP 4 — Prioritize ruthlessly

If multiple initiatives are competing for resources, apply:

**Impact vs effort matrix:** For each initiative, estimate impact (1-10) and
effort (1-10). Plot mentally. High impact + low effort = do first.

**Constraint check:** What's the bottleneck? Time, money, people, skill?
Which initiatives are blocked by the same constraint? Resolve the constraint
first, or accept that blocked initiatives won't happen.

**Kill candidates:** Which initiatives should be explicitly STOPPED to free
resources for higher-priority ones? Name them. Stopping things is a decision
that requires the same rigor as starting things.

## STEP 5 — Define success measurably

For the recommended strategy, define OKRs:

**Objective:** Qualitative, inspiring, one sentence.
**Key Results:** at least 2 quantitative measures — add more only while each new KR
tracks a distinct dimension of success; overlapping KRs measure nothing new. Each must be:
- Specific (exact metric, exact target)
- Measurable (can verify with a dashboard or report)
- Time-bound (by when)

Test: "Can someone other than me verify whether this KR is met?" If no, it's
not measurable enough.

## Output format

```
STRATEGIC ANALYSIS
├── Real job: [one sentence]
├── Top strength × opportunity: [the highest-leverage play]
├── Differentiation: [one sentence]
├── Top priority: [what to do first and why]
├── Kill list: [what to stop doing]
├── OKR: [objective + 2+ key results]
└── Confidence: [HIGH / MEDIUM / LOW]
```

<HARD-GATE>
Do NOT present a strategic recommendation without:
- The real job stated and confirmed with the user (not the stated goal)
- All 4 SWOT quadrants completed with 3+ items each
- At least one initiative explicitly on the kill list
- OKRs with measurable, verifiable key results

Rationalizations this skill catches:
- "The user already knows their strategy" — Then validate it. SWOT takes 2 minutes.
- "This is just a quick feature decision" — If it affects what to build vs how, it's strategy.
- "We don't need OKRs for this" — If you can't measure success, you can't verify it.
</HARD-GATE>
