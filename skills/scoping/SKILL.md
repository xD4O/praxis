---
name: scoping
description: >
  MANDATORY scoping protocol. You MUST invoke this skill when turning a vague or open-ended
  request into a defined build scope — "what should the MVP be", "scope this feature", "what
  should we build first", or any request to build something whose boundaries are fuzzy. Do NOT
  start building until the cut line is drawn. Do NOT leave what is OUT of scope unstated.
  Invoke BEFORE design or implementation. Does NOT apply to sequencing already-scoped work
  (use project-planning) or estimating it (use estimation).
---

# Scoping Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

Scope creep is not a discipline failure — it is a definition failure. If nothing was
declared OUT, everything is arguably IN. This protocol forces the boundary before a line
of code makes it expensive to move.

## STEP 1 — Enumerate candidate capabilities

List every capability the request could plausibly include — including the ones the user did
not say but would expect, and the ones they might be assuming are free but are not. A short
list here means you are scoping your first idea, not the problem.

## STEP 2 — Classify each MUST / SHOULD / WON'T-THIS-VERSION

Every capability gets exactly ONE label:
- **MUST** — the thing is useless or incoherent without it.
- **SHOULD** — real value, but the thing works and ships without it.
- **WON'T (this version)** — explicitly deferred or excluded, on purpose.

If everything is a MUST, you have not scoped — you have re-listed the request.

## STEP 3 — The WON'T list must be non-empty

Look at what you cut. If the WON'T list is empty, either the scope is genuinely tiny (say so
and show why) or you have not drawn a boundary — draw one now. A scope with no edges is the
thing that ships three months late.

## STEP 4 — Write an acceptance criterion for every MUST

Each MUST needs an observable acceptance test — "a user can X and sees Y", checkable by
someone other than you. A MUST you cannot write acceptance for is not defined yet; refine it
until you can, or it is not actually a MUST.

## STEP 5 — Report

```
SCOPE: [what is being built]
├── MUST: [capability → acceptance criterion, one line each]
├── SHOULD: [deferred-but-valuable capabilities]
├── WON'T (this version): [explicitly excluded — non-empty]
├── The cut line: [one sentence: what makes this version done]
└── Confidence: [HIGH / MEDIUM / LOW]
```

Confidence: **HIGH** — MUSTs all have acceptance criteria, cut line is unambiguous.
**MEDIUM** — some boundaries depend on unvalidated user need. **LOW** — you cannot tell a
MUST from a SHOULD without input the user has not given; ask before building.

<HARD-GATE>
Do NOT proceed to design or build until:
- Every enumerated capability is labeled exactly MUST, SHOULD, or WON'T
- The WON'T (this version) list is non-empty, or its emptiness is explicitly justified
- Every MUST has an observable acceptance criterion someone else could check
- A one-sentence cut line states what makes this version done

Starting to build with an all-MUST list and no stated exclusions is a protocol violation,
even if the user said "just build it".

Red flags that this skill catches:
- "It's all essential" — then nothing is prioritized. Something ships first; name it.
- "We'll figure out the boundary as we go" — the boundary found under deadline pressure is
  drawn by panic, not judgment. Draw it now.
- "The user will obviously want X too" — then it is a candidate capability. Label it, do not
  silently build it.
- "Acceptance criteria are for QA later" — an unwritten acceptance criterion is a MUST no one
  can confirm is met. Write it.
</HARD-GATE>

## Handoff

Once the scope is agreed, hand the MUST list to `project-planning` to sequence, and to
`estimation` if a number is needed. Re-run this skill whenever a new capability is proposed
mid-build — that is scope change, and it gets a label like everything else.
