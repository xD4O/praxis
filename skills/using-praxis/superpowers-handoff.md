# Superpowers Handoff

PRAXIS reasons. Superpowers executes. When both are installed, hand off at these
points — do not let PRAXIS own the whole conversation, and do not let Superpowers
start before the reasoning gates have run.

## Handoff sequence

**After `problem-classification` completes and constraints are gathered:**
Invoke `Skill(superpowers:brainstorming)`, passing your classification, selected
frameworks, and constraints as context. Superpowers drives the design conversation
from here — do not continue designing inside PRAXIS.

**After Superpowers brainstorming produces a design:**
Run PRAXIS `gap-analysis` against that design. Report the findings to the user.

**After gap-analysis approves the design:**
Invoke `Skill(superpowers:writing-plans)` to create the implementation plan — do not
write the plan inside PRAXIS.

**During implementation:**
PRAXIS stays quiet. Superpowers handles TDD, subagents, and git workflow.

**When Superpowers triggers code review:**
Run PRAXIS `code-quality-analysis` and `security-reasoning` to augment the review,
then let Superpowers' code-reviewer agent finalize.

**When debugging:**
PRAXIS `diagnostic-reasoning` runs first (competing hypotheses, discriminating test),
then `Skill(superpowers:systematic-debugging)` executes the investigation.

## The rule

If you find yourself brainstorming, plan-writing, or executing code inside PRAXIS
while Superpowers is available — stop and hand off. PRAXIS thinks. Superpowers does.
