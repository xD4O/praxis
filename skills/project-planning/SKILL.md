---
name: project-planning
description: >
  MANDATORY planning protocol. You MUST invoke this skill when turning a decided goal
  into an execution plan — breaking a project or feature into sequenced tasks, milestones,
  or a roadmap; "plan this out", "what's the build order", "break this into steps". Do NOT
  hand back a flat to-do list. Do NOT bury the riskiest work in the middle. Invoke BEFORE
  presenting any multi-step plan. Does NOT apply to estimating effort (use estimation) or
  choosing between approaches (use decision-analysis).
---

# Project Planning Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

A plan is not a list of things to do — it is a sequence chosen so that failure is cheap,
progress is visible, and nothing starts before what it depends on exists. A flat to-do
list ordered by what came to mind first is the failure this protocol prevents.

## STEP 1 — Decompose into done-able tasks

Break the goal into tasks. Apply the test to EACH: "Can I write a testable done-criterion
— a state someone else could confirm is reached?" ("done when a request to /login returns
a session cookie"). A task you cannot write a done-criterion for is not a task yet — split
it, or if it is an open question move it to an unknowns list and mark it for a spike.

## STEP 2 — Make dependencies explicit

For each task, name what must already exist before it can start. This ordering is forced
by the work, not by preference. A task with no stated dependency is either genuinely
foundational (say so) or you have not looked hard enough (look again).

## STEP 3 — Pull the riskiest task to the front

Name the single task with the most uncertainty or the highest cost-if-wrong — the one
most likely to invalidate the rest of the plan. It goes FIRST, or a timeboxed spike for it
does, so a wrong assumption is caught while it is cheap to fix. If your sequence puts it
late, re-sequence it or state explicitly why it cannot move earlier.

## STEP 4 — Group into demonstrable milestones

Group tasks into milestones. Each milestone must be a state you could SHOW someone — "a
user can log in and see their orders" — never an internal-progress label like "phase 1" or
"auth 50% done". A milestone with no observable deliverable is a schedule, not a plan.

## STEP 5 — Report

```
PLAN: [goal]
├── Tasks: [task → done-criterion, one line each; unknowns flagged]
├── Dependencies: [what-blocks-what, or "foundational" where none]
├── Riskiest-first: [the task/spike sequenced first, and why it dominates]
├── Milestones: [each a demonstrable state, in order]
└── Confidence: [HIGH / MEDIUM / LOW]
```

Confidence: **HIGH** — tasks all done-able, dependencies clear, riskiest work de-risked
early. **MEDIUM** — some tasks rest on unknowns now scheduled as spikes. **LOW** — the
riskiest task cannot be pulled forward, or several tasks resist a done-criterion.

<HARD-GATE>
Do NOT present the plan until:
- Every task has a testable done-criterion, or is a named unknown routed to a spike
- The single riskiest task is sequenced first (or spiked), with that choice stated
- Every dependency is explicit — no task's prerequisites are left implied
- Every milestone is a demonstrable state, not an internal-progress label

A flat task list with no done-criteria and no risk-driven ordering is a protocol
violation, even if the user asked for "just the steps".

Red flags that this skill catches:
- "I'll just list the obvious steps in order" — order by risk and dependency, not by
  recall. That reordering IS the plan.
- "The done-criteria are obvious, I don't need to write them" — unwritten done-criteria
  are where 'I thought that was finished' comes from. Write them.
- "We'll tackle the hard part once the easy parts are done" — that is exactly backwards;
  the hard part decides whether the easy parts were worth doing.
- "Milestone 1 is 'set up the project'" — set up toward what demonstrable state? Name it.
</HARD-GATE>

## Handoff

Once the plan is accepted, hand each milestone to execution. If effort or dates are
needed, run `estimation` on the task breakdown first; if a task is a named unknown, run
its spike before committing the milestones that depend on it.
