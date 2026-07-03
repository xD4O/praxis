---
name: architecture-reasoning
description: >
  MANDATORY architecture analysis. You MUST invoke this skill before making module boundary
  decisions, build-vs-buy choices, technology selections, data model designs, API contracts,
  or any structural decision that is expensive to reverse. Do NOT propose architecture
  without running reversibility classification, boundary analysis, and bottleneck
  identification. Invoke BEFORE writing implementation plans for non-trivial systems.
---

# Architecture Reasoning Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

You're making a structural decision. These are expensive to reverse. Reason carefully.

## STEP 1 — Classify the decision's reversibility

**Type 1 (one-way door):** Database schema, public API contract, core data model,
infrastructure provider, primary language/framework choice.
→ Requires full protocol below. Do not rush.

**Type 2 (two-way door):** Internal module boundaries, library choices, config
format, naming conventions, internal API between your own services.
→ Run abbreviated protocol (Steps 2 and 5 only). Decide fast, iterate.

## STEP 2 — Map what exists

Before designing anything new, understand what's already there.

- What components exist today?
- What are the current boundaries? (services, modules, packages)
- Where are the current pain points? (coupling, bottlenecks, tech debt)
- What constraints does the existing system impose on new design?

If this is greenfield (nothing exists), state that and skip to Step 3.

## STEP 3 — Evaluate build vs buy vs adopt

For each major component in the design, ask:

| Question | If YES → |
|---|---|
| Does a well-maintained OSS/SaaS solution exist? | Evaluate adopting it |
| Is this a commodity capability (auth, email, storage, logging)? | Buy/adopt, don't build |
| Is this your core differentiator? | Build it — this is where your value lives |
| Will you need to customize it beyond what exists? | Build if you'd be modifying its core rather than configuring its edges — a deep fork costs more than owning the code |

State each component's classification: BUILD / BUY / ADOPT.

## STEP 4 — Boundary analysis

For every proposed module or service boundary, verify:

**Cohesion test:** "Can I describe this module's purpose in one sentence without 'and'?"
- YES → Boundary is well-placed.
- NO → Module does too many things. Split it.

**Coupling test:** "If I change module A's internals, does module B need to change?"
- NO → Good separation.
- YES → Missing abstraction at the boundary. Add an interface.

**Data ownership test:** "Does exactly one module own each piece of data?"
- YES → Clean ownership.
- NO → Shared mutable state. This is where bugs breed. Assign a single owner.

**Communication test:** "How do these modules talk?"
- Direct function calls → Fine for monolith. Tight coupling for services.
- Events/messages → Loose coupling. Good for independent deployment.
- Shared database → Almost always wrong. Each module owns its data.

## STEP 5 — Spot the bottleneck

Apply Theory of Constraints: which single component limits the system's overall
capacity? Everything else is irrelevant until that bottleneck is addressed.

- Where does data queue up?
- Which step is slowest?
- Which component fails first under load?

Name the bottleneck explicitly. Your architecture must address it.

## Output format

```
ARCHITECTURE ANALYSIS
├── Decision type: [Type 1 / Type 2]
├── Components: [BUILD: x, y | BUY: z | ADOPT: w]
├── Boundaries: [cohesion ✓/✗ | coupling ✓/✗ | data ownership ✓/✗]
├── Bottleneck: [identified component and why]
├── Key risk: [the one thing most likely to require rework]
└── Confidence: [HIGH / MEDIUM / LOW]
```

<HARD-GATE>
For Type 1 decisions: do NOT proceed to implementation planning until all 5
steps are complete and the user has confirmed the architecture.

Type 1 decisions with MEDIUM or LOW confidence require explicit human sign-off
with the risks stated clearly. Do not bury risks in optimistic framing.
</HARD-GATE>

## Superpowers handoff

After architecture analysis is complete and user confirms:

If Superpowers is installed → invoke `Skill(superpowers:brainstorming)` if design
exploration is needed, or `Skill(superpowers:writing-plans)` if the architecture is
confirmed. Pass your build/buy/adopt classifications, boundary analysis, and bottleneck
identification as context. Do NOT write the implementation plan inside this skill.
PRAXIS architected. Superpowers plans and builds.

If Superpowers is NOT installed → proceed to implementation planning yourself using
the architecture analysis as the foundation.
