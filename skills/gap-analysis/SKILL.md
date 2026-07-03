---
name: gap-analysis
description: >
  MANDATORY validation. You MUST invoke this skill before presenting any design, plan,
  architecture decision, or significant recommendation as final. Runs 7 cognitive debiasing
  checks: inversion, second-order effects, MECE coverage, map vs territory, adversarial,
  simplicity, and reversibility. Do NOT present conclusions without running all 7 checks.
  Invoke after brainstorming produces a design, after a plan is drafted, before any
  irreversible action, or when asked to validate or review an approach.
---

# Gap Analysis Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

You have produced a design, plan, or recommendation. Before presenting it as final,
you MUST run all 7 checks below. Do not skip any. Report each result explicitly.

If your harness supports subagents, dispatch these checks to a fresh-context reviewer
using `agents/reasoning-reviewer.md` — a reviewer that has not seen your design's
justifications catches what self-review misses. Required at the DEEP tier; recommended
whenever the decision is hard to reverse.

## CHECK 1 — Inversion

Ask: "How would I guarantee this fails?"

List at least 3 specific failure modes; keep listing while distinct ones come to mind,
stop when candidates turn contrived. For each, verify your solution prevents it.
If any failure mode is not prevented, flag it as an open risk.

## CHECK 2 — Second-order consequences

Ask: "And then what?" three times.

- 1st order: [the immediate intended effect]
- 2nd order: [the effect of that effect — often unintended]
- 3rd order: [the cascading consequence — often counterintuitive]

If 2nd or 3rd order effects are negative, state whether they're acceptable or
require design changes.

## CHECK 3 — MECE coverage

Ask: "Have I covered the entire problem space with no gaps and no overlaps?"

List the dimensions you've addressed. Identify any dimension you haven't
addressed. Gaps are where surprises live.

## CHECK 4 — Map vs territory

Ask: "Where does my model diverge from reality?"

List at least 3 things you simplified, assumed, or ignored — more if you know of them.
For each, state the risk if reality differs from your model.

## CHECK 5 — Adversarial

Ask: "How would a hostile actor exploit this? How would a careless user break this?"

Identify the weakest point. State whether it's acceptable or needs hardening.

## CHECK 6 — Simplicity

Ask: "Is there a simpler solution I'm overlooking?"

If yes, state why you chose the more complex approach. The justification must
be concrete, not "it might be needed later" (that's YAGNI violation).

## CHECK 7 — Reversibility

Ask: "Is this decision reversible?"

- If YES (Type 2): Proceed. Note that it can be unwound if wrong.
- If NO (Type 1): Have you applied proportional rigor? Would you bet your
  job on this recommendation? If not, what additional verification is needed?

## Output format

After completing all 7 checks, summarize:

```
GAP ANALYSIS COMPLETE
├── Inversion: [X/Y failure modes mitigated] [open risks if any]
├── Second-order: [acceptable / requires changes]
├── MECE: [complete / gap in: ___]
├── Map vs territory: [top risk: ___]
├── Adversarial: [weakest point: ___]
├── Simplicity: [simplest viable / justified complexity]
├── Reversibility: [Type 1 / Type 2]
└── Confidence: [HIGH / MEDIUM / LOW / INSUFFICIENT]
```

<HARD-GATE>
Do NOT present a design, plan, or recommendation as final until all 7 checks
are complete and reported. If any check reveals a critical issue (unmitigated
failure mode, negative 2nd-order effect, MECE gap, or Type 1 decision with
LOW confidence), you MUST address it before proceeding.

Rationalizations that skip checks:
- "This is straightforward" — straightforward things don't need gap analysis.
  Non-trivial things do. If you're running this skill, it's non-trivial.
- "The user is in a hurry" — a 2-minute check saves a 2-week failure.
- "I already considered this" — show your work. Implicit checks don't count.
</HARD-GATE>

## Superpowers handoff

After all 7 checks pass and the design is validated:

If Superpowers is installed → invoke `Skill(superpowers:writing-plans)` to create the
implementation plan. Pass the validated design and any issues flagged during gap analysis.
Do NOT write the plan inside PRAXIS. PRAXIS validated. Superpowers plans.

If Superpowers is NOT installed → proceed to implementation planning yourself.
