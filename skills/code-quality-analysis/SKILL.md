---
name: code-quality-analysis
description: >
  MANDATORY code review protocol. You MUST invoke this skill when writing significant code
  (not one-liners), reviewing PRs or diffs, refactoring modules, or when code quality is
  requested. Runs 15 structural checks across readability, structure, safety, purity, and
  design. Complements TDD — tests verify behavior, this verifies design quality. Do NOT
  ship code with 3+ safety failures without remediation.
---

# Code Quality Analysis Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

Tests verify that code WORKS. This protocol verifies that code is WELL-DESIGNED.
Run these checks on any significant code you write or review.

## THE 15 CHECKS

Work through each. Mark PASS, FAIL, or N/A. Do not skip any applicable check.

### Readability

**1. NAMING** — Does every variable, function, and class name reveal its intent?
- `processData()` → FAIL. `extractValidEmails()` → PASS.
- Booleans read as questions: `isValid`, `hasPermission`, `canExecute`.
- No abbreviations a new reader couldn't understand.

**2. FUNCTION SIZE** — Does every function do exactly one thing?
- Length is the smell: past ~20 lines a function has usually accreted a second job.
  Extract methods. (A long but irreducible unit — e.g. a flat dispatch table — can pass.)
- Can you describe what the function does without the word "and"?

**3. NESTING DEPTH** — Is anything nested deeper than 2 levels?
- Every nesting level is a condition the reader must hold in their head at once.
  Flatten with guard clauses. Return early for invalid cases.
- Happy path should be at indent level 1.

### Structure

**4. SINGLE RESPONSIBILITY** — Does each module/class have exactly one reason to change?
- Can you describe it in one sentence without "and"?
- If it handles both parsing AND validation AND storage, split it.

**5. COUPLING** — Can you change module A without touching module B?
- Count the imports. More imports = more coupling.
- Are there method chains longer than 2 dots? Each extra dot couples this code to
  another object's internals (Law of Demeter).

**6. COHESION** — Is everything inside this module related to the same concern?
- Would removing any function make the module incomplete?
- Would any function be more at home in a different module?

### Safety

**7. FAIL FAST** — Do errors surface immediately with clear messages?
- No empty catch blocks.
- No silently defaulting to zero/null/empty on bad input.
- Errors include context: what input, what state, what was expected.

**8. IDEMPOTENCY** — What happens if this operation runs twice?
- If the answer isn't "same as running once," add idempotency controls.
- State-changing operations need idempotency keys or upsert logic.

**9. INPUT VALIDATION** — Are all inputs validated at the boundary?
- Every public function/API endpoint validates its arguments.
- Validation happens server-side, not just client-side.

### Purity

**10. COMMAND-QUERY SEPARATION** — Does every function either return data OR change state?
- Functions starting with get/find/is/has: pure queries, no side effects.
- Functions starting with set/update/delete/create: commands, no return value.
- If you wrote "getAndUpdate," split it.

**11. IMMUTABILITY** — Is data mutated, or are new copies created?
- Prefer `const` over `let`. Prefer `map/filter/reduce` over mutating loops.
- Don't mutate function arguments — callers don't expect their data to change out from
  under them. Return new objects, unless the function's documented contract is in-place
  mutation for a measured hotspot.

**12. SURPRISE CHECK** — Would a reader be surprised by ANY behavior?
- Read only the function signature. Predict what it does. Check.
- Constructors that open connections = surprise. Getters with side effects = surprise.

### Design

**13. COMPOSITION** — Is inheritance used where composition would work?
- "Has-a" is almost always better than "is-a."
- Hierarchies deeper than 2 levels couple every subclass to every ancestor's
  implementation — a change anywhere ripples everywhere. Refactor to composition.

**14. ORTHOGONALITY** — If you change feature X, how many other files change?
- Ideal answer: 1 (the file implementing X).
- If more than 3 files change, there's an abstraction boundary missing.

**15. SIMPLICITY** — Is this the simplest approach that solves the problem?
- Any feature built for "maybe someday"? Delete it (YAGNI).
- Any logic duplicated? Extract it (DRY).
- Any cleverness that a junior engineer couldn't follow? Simplify it (KISS).

## Output format

After completing all checks:

```
CODE QUALITY ANALYSIS
├── Readability:  Naming [P/F] | Size [P/F] | Nesting [P/F]
├── Structure:    SRP [P/F] | Coupling [P/F] | Cohesion [P/F]
├── Safety:       FailFast [P/F] | Idempotent [P/F] | Validation [P/F]
├── Purity:       CQS [P/F] | Immutable [P/F] | NoSurprise [P/F]
├── Design:       Composition [P/F] | Orthogonal [P/F] | Simple [P/F]
├── Score:        [X/15 passed]
└── Action items: [list any FAIL items with specific fix]
```

<HARD-GATE>
Code with 3+ FAIL items in the Safety or Structure categories should not
ship without remediation. Flag these as blocking issues in code review.

Rationalizations this skill catches:
- "It works" — Working is the minimum bar. Well-designed is the standard.
- "We'll refactor later" — Later never comes. Fix it now while context is fresh.
- "It's just a prototype" — Prototypes become production. Build the habit.
</HARD-GATE>

## Superpowers handoff

After the 15-check analysis is complete:

If Superpowers is installed → pass the quality report to `Skill(superpowers:requesting-code-review)`
or the active Superpowers review workflow. FAIL items become required fixes in the review.
Safety and Structure FAILs are blocking items that Superpowers' code reviewer should enforce.

If Superpowers is NOT installed → present the report to the user with specific fix
recommendations for each FAIL item.
