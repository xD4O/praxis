---
name: interface-design-reasoning
description: >
  MANDATORY interface-design protocol. You MUST invoke this skill before designing or
  significantly changing a user-facing interface, visual direction, information hierarchy,
  or interaction flow, and when judging whether a UI is intentional and coherent. Do NOT
  invoke for typo or copy-only edits, trivial CSS adjustments, backend-only work, or
  code-compliance-only accessibility audits.
---

# Interface Design Reasoning Protocol

EXTREMELY_IMPORTANT: Follow every step in order. This protocol decides what the interface
should communicate and feel like. It does not replace implementation, accessibility testing,
or rendered verification.

## STEP 1 — Ground the design

Inspect the relevant product context, rendered surface or code, existing components, tokens,
and conventions. State:

- the user, their job, and their physical or operational context
- the primary information or action
- the existing design language to preserve
- constraints, evidence, and assumptions

Classify the surface as **product UI**, where design serves repeated work, or **brand UI**,
where design itself carries more of the message. If evidence is unavailable, label assumptions
and cap confidence at MEDIUM. Do not invent user research, brand attributes, or constraints.

## STEP 2 — Write the experience thesis

Complete one sentence:

> For [user] doing [job] in [context], the interface should feel [two specific qualities]
> because [reason], and should make [primary information/action] dominant.

Translate each quality into an observable consequence for hierarchy, layout, type, color,
shape, imagery, or motion. Delete qualities with no visible consequence. The thesis fails if
it could describe an unrelated product unchanged.

## STEP 3 — Map the experience

Trace the shortest successful path from entry to outcome. At each relevant point, define what
the user sees, can do, receives as feedback, and uses to recover. Include applicable loading,
empty, error, success, disabled, long-content, narrow-viewport, keyboard, and touch conditions.
Start at the actual entry condition; do not assume required input already exists. Do not invent
states the product cannot enter. A known relevant state is never just a label: specify feedback,
available actions, and recovery even when asked to omit it. Revise if the primary action is
ambiguous or a common state becomes a dead end. Treat a request to omit a reachable state as
design input to reject, not as permission to skip this step.

## STEP 4 — Compare credible directions

Produce two materially different directions, or compare the existing design with one credible
alternative. A color swap is not a different direction. For each direction, state:

- hierarchy and composition
- relationship to the existing system
- one project-specific signal
- main benefit and main cost or risk

Choose one and reject the other for a reason tied to the user, context, or product. Do not
blend both by default. If missing evidence blocks a final direction, still compare the request
with the lowest-assumption alternative—usually preserving the current system until evidence exists.

## STEP 5 — Run the taste gate

Record PASS or FAIL with concrete evidence for every row:

| Criterion | Required evidence |
|---|---|
| **Intentionality** | Primary hierarchy and major choices trace to the experience thesis |
| **Coherence** | Type, color, spacing, shape, imagery, and motion follow one system; exceptions are justified |
| **Specificity** | A meaningful choice comes from this product's content, workflow, data, or identity and cannot be transplanted unchanged |
| **Reflex rejection** | Name the obvious category default and knee-jerk opposite; record why their first- and second-order effects do not serve this job |
| **Restraint** | Every decorative element has a job; unsupported decoration is removed |
| **Fitness** | Relevant states, breakpoints, input modes, contrast, semantics, and focus behavior have no known blocker |

"Clean," "modern," "premium," anti-pattern avoidance, and trend vocabulary are not evidence.
If aesthetic intent is offered to excuse a Fitness failure, name and reject that trade.
For Reflex rejection, separate the immediate hierarchy or use effect from downstream
accessibility, performance, or maintenance cost.
On any FAIL, revise the direction and rerun the full gate. If evidence is unavailable or a
blocking usability or accessibility issue remains, return BLOCKED rather than passing on taste.

## STEP 6 — Define rendered verification

Name the smallest rendered evidence needed to validate the recommendation: surfaces and states,
representative narrow and wide viewports, keyboard or touch paths, real or adversarial content,
and observable success and failure conditions. Do not claim implementation quality from a
design rationale or code inspection alone.

## Output format

```
INTERFACE DESIGN ANALYSIS
├── User / job / context: [...]
├── Experience thesis: [...]
├── Primary path and states: [...]
├── Directions: [chosen: ... | rejected: ... because ...]
├── Taste gate: Intentionality [P/F] | Coherence [P/F] | Specificity [P/F]
│               Reflex rejection [P/F] | Restraint [P/F] | Fitness [P/F]
├── Rendered verification required: [...]
├── Result: [READY / REVISE / BLOCKED]
├── Open assumptions: [...]
└── Confidence: [HIGH / MEDIUM / LOW / INSUFFICIENT]
```

<HARD-GATE>
Do NOT present an interface recommendation as final unless every taste criterion has PASS
evidence, one credible alternative was explicitly rejected for a named reason, one meaningful
project-specific choice cannot be transplanted unchanged, and no known blocking usability or
accessibility gap remains. Do not complete the analysis, even as BLOCKED, until every known
relevant state specifies feedback, available actions, and recovery.

Red flags:
- "It looks clean, so it passes" — cleanliness can still be generic.
- "I removed gradients and card grids, so it has taste" — avoiding clichés is a floor, not a direction.
- "The design system decided everything" — it constrains components, not hierarchy or intent.
- "Responsive and accessibility can come later" — a direction that fails real use does not pass.
- "Animation will add personality" — motion cannot rescue weak hierarchy or absent identity.
</HARD-GATE>
