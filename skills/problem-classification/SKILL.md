---
name: problem-classification
description: >
  MANDATORY first step. You MUST invoke this skill before brainstorming, designing, or
  planning any non-trivial work. Do NOT start asking clarifying questions on your own —
  this skill's gates ARE the clarifying questions. Invoke when the user asks to build,
  design, plan, create, architect, or implement anything substantial. Do NOT skip this
  because the task seems straightforward. Straightforward-seeming tasks with wrong framing
  produce the most expensive failures.
---

# Problem Classification Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

You MUST complete this protocol before brainstorming, designing, or planning. Do not skip
steps. Do not combine steps. Work through each gate sequentially.

## GATE 1 — Name the problem type

Read the user's request. Classify it as exactly ONE of these:

| Type | Signature | Example |
|---|---|---|
| **NEW-BUILD** | Creating something that doesn't exist | "Build a notification service" |
| **EXTEND** | Adding capability to something that exists | "Add OAuth to our API" |
| **FIX** | Something is broken or wrong | "API returns 500 intermittently" |
| **OPTIMIZE** | Something works but needs to be better | "Reduce query latency from 800ms" |
| **DECIDE** | Choosing between alternatives | "Monolith vs microservices?" |
| **ANALYZE** | Understanding something to assess it | "Is our auth implementation secure?" |

State the type explicitly: "This is a [TYPE] problem."

## GATE 2 — Identify the constraint envelope

List the hard constraints. These are non-negotiable boundaries. Ask the user if any
are unclear. Do not invent constraints the user hasn't stated.

Answer each:
- **Time:** Is there a deadline? What's the urgency?
- **Scope:** What's in and out of bounds?
- **Resources:** What tools, languages, infrastructure are available?
- **Quality:** What's the failure tolerance? (prototype vs production vs safety-critical)
- **Dependencies:** What existing systems must this integrate with?

If the user hasn't specified a constraint, ask. Do not assume.

## GATE 3 — Select reasoning frameworks

Based on the problem type, select at least 2 frameworks that materially change how you
will approach this problem. Stop adding once another framework would not change the
reasoning — the ceiling is judgment, not a count.

| Problem type | Primary framework | Supporting frameworks |
|---|---|---|
| NEW-BUILD | First Principles | Constraint-Driven Design, TRIZ |
| EXTEND | Separation of Concerns | Cohesion/Coupling, Backward Compatibility |
| FIX | Abductive Reasoning | Strong Inference, 5 Whys |
| OPTIMIZE | Theory of Constraints | Pareto (80/20), Measurement-First |
| DECIDE | Expected Value Analysis | Reversibility Test, Second-Order Thinking |
| ANALYZE | STRIDE + MECE | Inversion, Red Team |

State your selections explicitly: "Selected frameworks: [X], [Y], [Z]."
State one sentence for WHY each framework fits this specific problem.

## GATE 4 — Frame the approach

In 3-5 sentences, state:
1. What the problem actually is (not what the user said — what it actually is)
2. What approach you'll take and why
3. What the first question you need answered is

Present this to the user. Get confirmation before proceeding.

<HARD-GATE>
Do NOT proceed to brainstorming, design, or implementation until:
- Problem type is named
- Constraints are enumerated (or confirmed as unconstrained)
- Frameworks are selected with justification
- User has confirmed the approach framing

If any gate is incomplete, stop and complete it. Do not skip ahead because
the task "seems straightforward." Straightforward-seeming tasks with wrong
framing produce the most expensive failures.
</HARD-GATE>

## Superpowers handoff

After all 4 gates are complete and the user has confirmed the approach:

If Superpowers is installed → invoke `Skill(superpowers:brainstorming)` immediately.
Pass your problem type, selected frameworks, and constraints as context to Superpowers.
Let Superpowers drive the design conversation from here. Do NOT continue designing
inside this skill. PRAXIS classified. Superpowers brainstorms.

If Superpowers is NOT installed → proceed with your own design conversation using the
selected frameworks. You are the only reasoning layer available.
