---
name: skill-creation
description: >
  MANDATORY meta-protocol for changing PRAXIS itself. You MUST invoke this skill when you
  (or an agent you dispatched) are about to create a new skill, substantially modify an
  existing skill, or add a framework to the routing index in a PRAXIS-format repository.
  Do NOT write a SKILL.md, rework a protocol's gates, or open a PR against this repo
  without completing these gates first. Does NOT apply to ordinary user tasks, application
  code, or documentation outside the skills system — only to changes to the skills themselves.
---

# Skill Creation Protocol

EXTREMELY_IMPORTANT: This is a MANDATORY protocol, not a suggestion. Follow every step.
Do not skip steps. Do not combine steps. Do not summarize. Work through each gate in order.

You are about to create or substantially modify a PRAXIS skill. That is a change to the
reasoning layer every downstream session depends on. Do NOT write a single line of the
skill until Gates 1-2 pass. Do NOT open a PR until all 6 gates pass.

## GATE 1 — Name the trigger

State the specific, named failure or reasoning gap driving this change:

- **Exact session/incident:** Where did an agent fail? Name the session, task, or transcript.
- **Exact trigger:** What input or situation produced the failure?
- **Exact failure:** What did the agent do wrong, and what should it have done?

PASS: You can fill in all three fields with concrete facts another person could verify.
FAIL: The trigger is "the user asked to improve X," "this could be better," or any request
without an experienced failure behind it. If so, STOP and push back: ask your human partner
what broke. Do not proceed on speculation. Speculative improvements are rejected by policy.

## GATE 2 — Search for prior art

Before writing anything, search and record results for each:

1. **Existing skills:** Read `skills/` and the routing index. Does a skill already cover
   this reasoning gap, even partially?
2. **Open PRs:** Search open PRs touching the same skill or gap.
3. **Closed PRs:** Search closed/rejected PRs — if this was tried and rejected, you must
   address the rejection reason, not resubmit it.

PASS: All three searches performed, results listed, and no unaddressed duplicate exists.
FAIL: Any search skipped, or a duplicate exists. If an existing skill partially covers the
gap, propose modifying it instead of creating a new one. Do NOT proceed until resolved.

## GATE 3 — Structural conformance

Draft the skill, then verify each item as a binary check:

- [ ] **Under 150 lines.** Count them. Over 150 means it does too many things — split or cut.
- [ ] **Every step imperative.** Grep your draft for "consider," "you might," "optionally,"
      "it may help" — each hit is a violation. Rewrite as "Do X."
- [ ] **At least one `<HARD-GATE>`** that blocks proceeding without completing prior steps.
- [ ] **Red Flags section** naming the specific rationalizations agents use to skip this skill.
- [ ] **Structured output format** so results are auditable, not prose summaries.
- [ ] **Confidence levels** on output, wherever the skill produces an analysis or recommendation.
- [ ] **It is a protocol, not a reference.** If the draft says "here are N frameworks you
      could use" without enforcing steps, it is a reference document and will be rejected.

PASS: Every box checked, verified against the actual draft — not assumed.
FAIL: Any unchecked box. Fix the draft before proceeding.

## GATE 4 — One problem per PR

List every file the change touches and every distinct improvement it makes.

PASS: Every touched file and every change traces back to the single trigger named in Gate 1.
FAIL: The diff contains a second improvement, drive-by fix, formatting cleanup, or index
addition unrelated to the Gate 1 trigger. Split it: keep only the Gate 1 change, and open
each unrelated change as its own future PR with its own Gate 1 trigger. Adding a framework
name to the routing index without its enforcement protocol also fails here — index entry
and skill ship together or not at all.

## GATE 5 — Evidence before merge

"I think this reads better" is NOT evidence. Produce the artifact for your change type:

- **NEW skill:** Walk the complete protocol against at least one realistic scenario
  (preferably the Gate 1 incident itself). Record each gate's input and output. The
  walkthrough must show the skill producing the intended behavior — and should include
  at least one adversarial case where a gate correctly FAILS and blocks progress.
- **MODIFICATION:** Produce a before/after comparison: the old wording, the failure it
  caused (from Gate 1), the new wording, and how the new wording prevents that specific
  failure. "This wording caused the agent to skip Step 3; this revision fixed it" is the bar.

PASS: The evidence artifact exists, is included in the PR description, and demonstrates
the specific problem is solved.
FAIL: Evidence is an opinion, an aesthetic judgment, or absent. Do NOT open the PR.

## GATE 6 — Human approval on the complete diff

Show your human partner the COMPLETE diff — every changed line, not a summary — plus the
Gate 1 trigger and Gate 5 evidence. Ask for explicit approval.

PASS: The human explicitly approved this exact diff.
FAIL: Approval is implied, stale (the diff changed after approval), or given to a summary.
Re-request approval on the current diff. Nothing ships without it.

<HARD-GATE>
Do NOT create, modify, or open a PR for a PRAXIS skill unless ALL of these hold:
- A concrete, named failure or gap triggers the change (Gate 1) — no speculative improvements.
- No existing skill or open/closed PR already covers it (Gate 2).
- Exactly ONE problem per PR (Gate 4) — bulk changes are split, no exceptions.
- Evidence exists before merge: walkthrough for new skills, before/after for modifications (Gate 5).
- A human partner explicitly approved the complete, current diff (Gate 6).
If any gate fails, STOP at that gate. Do not proceed and "come back to it later."
</HARD-GATE>

## Red Flags — rationalizations this skill catches

- "This is a small change, it doesn't need the full process." — Small changes to an
  enforcement protocol change agent behavior everywhere it runs. Run the gates.
- "I'll just add it to this other PR since I'm already touching that file." — That is a
  bulk change. One problem per PR. Open a second PR.
- "The improvement is obviously good, I don't need evidence." — Obviousness is an opinion.
  Gate 5 requires an artifact.
- "The user asked me to improve the repo, so I have a trigger." — A request is not a
  failure. Gate 1 requires a named incident. Ask what broke.
- "A reference section would make the skill more helpful." — Reference documents disguised
  as skills are rejected. Every addition must be an enforceable step.
- "I'll get approval after I open the PR." — Gate 6 comes before shipping, not after.
- "It's 160 lines but they're all necessary." — Then it does too many things. Split or cut.

## Output

Report the completed checklist in this form before opening (or declining to open) a PR:

```
SKILL-CREATION CHECKLIST: [skill-name] ([NEW / MODIFICATION])
├── Gate 1 Trigger:    [PASS/FAIL] [session + trigger + failure, one line]
├── Gate 2 Prior art:  [PASS/FAIL] [skills/PRs searched, duplicates found: none / ___]
├── Gate 3 Structure:  [PASS/FAIL] [line count: N/150; unchecked items if any]
├── Gate 4 Scope:      [PASS/FAIL] [one problem confirmed / split required: ___]
├── Gate 5 Evidence:   [PASS/FAIL] [walkthrough / before-after, artifact location]
├── Gate 6 Approval:   [PASS/FAIL] [approved by ___ on complete diff / pending]
├── Confidence:        [HIGH / MEDIUM / LOW]
└── VERDICT:           [APPROVED-FOR-PR / NOT-YET — blocked at Gate N: ___]
```

If the verdict is NOT-YET, name the failing gate and the exact action required to pass it.
