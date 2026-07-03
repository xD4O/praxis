---
name: using-praxis
description: >
  Reasoning router — invoke before starting any non-trivial task: designing a system
  or feature, debugging a failure, architecture decisions, security-sensitive code,
  trade-off choices, significant refactors, reviewing a design or plan, or strategy.
  Classifies the problem, routes to the matching reasoning protocol, and validates
  conclusions before they are final. Skip only for trivial mechanical work: typo
  fixes, renames, one-liners, factual questions, running commands.
---

# PRAXIS Router

PRAXIS does two things before any code or plan is produced:

1. **Converge** — make sure you and the user mean the same thing.
2. **Reason** — apply the right framework for the problem type, then validate the result.

## Complexity gate

**Trivial — respond directly, no protocol:** typo fixes, renames, one-liners, factual
questions, running commands, formatting, syntax explanations, simple file edits, git
operations, package installs.

**Everything else routes below.** If unsure, run the QUICK tier — it costs under a
minute. And if you catch yourself thinking "I can handle this directly" or "this is
straightforward enough" on a task that matches a routing row, treat that impulse as
the signal to route, not to skip.

## Depth tiers

Scale rigor to irreversibility × blast radius:

- **QUICK** — run the protocol's gates mentally; report a 3–5 line summary. For small,
  reversible work, or when the user asks for brevity.
- **STANDARD** — the full protocol as written. Default for non-trivial work.
- **DEEP** — full protocol plus fresh-context review (see gap-analysis). Required for
  Type 1 hard-to-reverse decisions: schemas, public API contracts, core data models,
  infrastructure choices.

## Routing

Identify **every** row that applies — protocols compose, they don't compete:

| The task involves | Protocol |
|---|---|
| Starting any new design or feature | `problem-classification` |
| Architecture, module boundaries, build-vs-buy | `architecture-reasoning` |
| Auth, authorization, crypto, input handling, PII, payments | `security-reasoning` |
| Choosing between options, trade-offs, priorities | `decision-analysis` |
| Debugging, investigating, diagnosing failures | `diagnostic-reasoning` |
| Writing, reviewing, or refactoring significant code | `code-quality-analysis` |
| Business strategy, positioning, roadmap priorities | `strategic-reasoning` |
| **Any** design, plan, or recommendation about to be final | `gap-analysis` — always last |

Ordering: `problem-classification` first when the work is new. `security-reasoning`
whenever its row matches, in addition to the others. `gap-analysis` last, before
anything is presented as final.

**Loading a protocol:** invoke it as a skill — `praxis:<name>` when installed as a
plugin, `<name>` when skills are installed flat. If your harness has no skill
invocation, read `skills/<name>/SKILL.md` from the PRAXIS directory and follow it
as written.

<HARD-GATE>
The three invariants — everything else scales with the depth tier, these do not:

1. No non-trivial design, plan, or recommendation is presented as final without
   gap-analysis.
2. No code is written at a trust boundary without STRIDE from security-reasoning.
3. Every analysis ends with a confidence level and the specific assumptions that
   would change it.
</HARD-GATE>

## User override — informed consent

The user is the principal. If they ask to skip analysis:

1. State specifically what gets skipped and the concrete risk, in one line.
2. Offer the QUICK tier as a 30-second alternative.
3. Then follow their call, and note the waiver in your output.

Never silently comply, and never overrule.

## Autonomous mode

When no user is available to answer (headless, CI, cron, subagent), do not stall on a
confirmation gate: state the assumption you are making in writing, proceed, cap
confidence at MEDIUM, and surface the open questions at the end of your output.

## Anti-theater check

A protocol run only counts if it could have changed something. After completing any
protocol, name the check that altered your approach. If nothing changed, either show
the evidence that the original approach survived genuine scrutiny, or rerun the
weakest check adversarially. Filling templates with plausible filler is a protocol
violation, not compliance.

## Confidence scale

- **HIGH (90%+)** — multiple independent checks passed; evidence cited.
- **MEDIUM (70–89%)** — reasoning is sound; unverified assumptions listed.
- **LOW (50–69%)** — significant uncertainty; state what information would raise it.
- **INSUFFICIENT (<50%)** — do not recommend; escalate to the user.

## Superpowers integration

If the Superpowers plugin is installed, PRAXIS reasons and Superpowers executes. Read
`superpowers-handoff.md` in this skill's directory for the exact handoff points.
