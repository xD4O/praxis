---
name: domain-modeling
description: >
  MANDATORY modeling protocol. You MUST invoke this skill when designing a data model, domain
  model, database schema, or the core entities and relationships of a system — "design the
  schema", "model this domain", "what tables/entities do we need". Do NOT jump to tables or
  classes before the invariants are named. Do NOT leave illegal states representable. Invoke
  BEFORE writing migrations, ORM models, or type definitions for the domain. Does NOT apply to
  choosing a database engine (use architecture-reasoning).
---

# Domain Modeling Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

A schema that permits a state the business forbids is a bug you will spend months patching in
application code. The model's job is to make illegal states impossible, not merely unlikely.
Name the rules before you name the columns.

## STEP 1 — Name entities in the domain's own language

List the core entities using the words a domain expert would use (ubiquitous language). If
you are inventing names no one in the business would recognize, you are modeling your first
guess at the solution, not the domain — go back to the domain's vocabulary.

## STEP 2 — State each entity's invariant

For EVERY entity, write at least one rule that must ALWAYS be true ("an order's total equals
the sum of its line items"; "a lent copy has exactly one borrower"). An entity with no
invariant is a bag of fields — question whether it is really an entity or just attributes of
another one.

## STEP 3 — Assign lifecycle ownership across relationships

For every relationship, name which side OWNS the lifecycle (creates/deletes the other) and
which merely references it. Unowned or doubly-owned relationships are where orphan rows and
cascade-delete surprises come from. State the cardinality too (1:1, 1:N, N:M).

## STEP 4 — Make illegal states unrepresentable

List the states the domain FORBIDS ("a copy lent to two members at once", "a hold on a copy
that is available"). For each, check the current model: does it still allow that state? If
yes, change the model — a required field, a unique constraint, a type, a moved relationship —
so the state cannot be expressed. If it truly cannot be prevented structurally, flag it as
requiring a runtime guard and say why.

## STEP 5 — Report

```
DOMAIN MODEL: [system]
├── Entities: [entity → its invariant(s), one line each]
├── Relationships: [A—B, cardinality, which side owns lifecycle]
├── Illegal states forbidden: [state → made-unrepresentable how, or runtime-guarded + why]
└── Confidence: [HIGH / MEDIUM / LOW]
```

Confidence: **HIGH** — every entity has an invariant, ownership is unambiguous, forbidden
states are structurally prevented. **MEDIUM** — some rules rely on runtime guards. **LOW** —
core invariants are still unclear or ownership is contested; resolve before migrating.

<HARD-GATE>
Do NOT present the model until:
- Every entity has at least one stated invariant
- Every relationship names its owning side and cardinality
- Each domain-forbidden state is either made unrepresentable in the model, or explicitly
  flagged as only runtime-guarded with a reason

A schema presented as a list of tables and columns with no invariants and no forbidden-state
check is a protocol violation, even if it "looks complete".

Red flags that this skill catches:
- "I'll just add the obvious fields" — fields without invariants encode no rules; the illegal
  states leak into every query. State the rule first.
- "Ownership is obvious from the foreign key" — a foreign key says 'references', not 'owns'.
  Name who deletes whom.
- "We can validate that in the app layer" — sometimes true, but decide it deliberately per
  forbidden state, not as the default that lets the schema permit nonsense.
- "It's a simple domain" — simple domains still forbid states. Name three and check them.
</HARD-GATE>

## Handoff

Once the model holds, hand it to implementation for migrations/types, and to
`architecture-reasoning` if the model reveals a boundary or storage decision worth weighing.
