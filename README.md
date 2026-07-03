![Praxis Banner](assets/banner.png)


**PRAXIS - A reasoning methodology plugin for AI coding agents.**

Praxis makes your agent think before it acts — classifying problems, selecting the right reasoning frameworks for the problem type, enforcing cognitive checklists, and validating solutions before execution. It works standalone or alongside [Superpowers](https://github.com/obra/superpowers).

Superpowers tells agents **how to execute**. Praxis tells agents **how to think**. Together, your agent reasons deeply *then* executes precisely.

![How Praxis Works](assets/workflow.png)


## What it actually does

Without Praxis, you say "design an auth system" and your agent starts asking generic questions or writing code immediately.

With Praxis:

```
You: Help me design an authentication system for our API

Agent: Skill(praxis) — Successfully loaded skill

GATE 1 — Problem type: EXTEND (adding auth to existing API).
GATE 2 — Constraints needed before designing:
  1. Clients: First-party web? Mobile? Third-party devs? Server-to-server?
  2. Session shape: Long-lived browser sessions? Short-lived API calls?
  3. Compliance: HIPAA, PCI, SOC2?
  4. Build vs buy: Open to Auth0/Clerk, or self-hosted?
GATE 3 — Frameworks: Separation of Concerns + Backward Compatibility + STRIDE
GATE 4 — The real problem isn't "pick JWT vs sessions" — it's matching auth
  architecture to your client mix, trust boundaries, and operational capacity.

Confidence: INSUFFICIENT (<50%) — cannot recommend without constraint envelope.
```

The agent classified the problem, selected reasoning frameworks, asked constraint-specific questions instead of generic ones, reframed the real problem, and reported calibrated confidence — all before writing a single line of code. Another example below:

![example_problem_classification](assets/example_problem_classification.jpg)
## Test results

Built through iterations of testing and tuning. Every critical test passes.

| Test | What it proves | |
|---|---|---|
| T1: Trivial skip | Doesn't over-trigger on "fix this typo" |
| T4: Non-trivial activate | Fires problem-classification on design tasks |
| G2: Gap analysis | Runs all 7 cognitive debiasing checks |
| G3: Security auto-detect | Recognizes auth code without being told "security" |
| G4: Informed-consent skip | Names the skipped risk, offers the QUICK tier, then respects the user's call |
| Q1: Diagnostic quality | 5 hypotheses + Strong Inference discriminating test |
| Q2: Decision quality | Adds "do nothing," asks weights, steelmans the loser |
| Q3: Code quality | Catches 17 violations including SQLi, MD5, no auth |
| Q4: Architecture quality | Reversibility, boundary analysis, bottleneck ID |
| S1: Superpowers handoff | Praxis reasons first, then Superpowers executes |

## The 13 skills

Each skill is a behavioral protocol with mandatory gates — not a reference document to browse.

| Skill | What it enforces | When it fires |
|---|---|---|
| **intent-alignment** | Spec mirroring, three-interpretations check, misunderstanding premortem | First, whenever a request could be read more than one way |
| **problem-classification** | 4 gates: name type → enumerate constraints → select frameworks → frame approach | Before any new design or feature |
| **gap-analysis** | 7 checks: inversion, second-order, MECE, map vs territory, adversarial, simplicity, reversibility | Before finalizing any design or plan |
| **security-reasoning** | STRIDE per trust boundary, attack surface table, top 3 mitigations | Auth, crypto, input handling, payments |
| **diagnostic-reasoning** | 5 hypotheses, Strong Inference discriminating test, 5 Whys root cause | Debugging and failure investigation |
| **code-quality-analysis** | 15 pass/fail checks across readability, structure, safety, purity, design | Writing, reviewing, or refactoring code |
| **architecture-reasoning** | Reversibility classification, build/buy/adopt, boundary analysis, bottleneck ID | Architecture and module decisions |
| **decision-analysis** | Weighted criteria, expected value, second-order, pre-mortem, steelman | Trade-offs and choosing between alternatives |
| **strategic-reasoning** | JTBD, SWOT with cross-referencing, kill list, measurable OKRs | Business strategy and roadmap decisions |
| **performance-reasoning** | Baseline before changes, Theory of Constraints, same-methodology verification | Making working code faster, cheaper, or smaller |
| **testing-strategy** | Test-type classification, high-value failure modes, fail-then-pass regression proof | Deciding what to test; verifying a bug fix is real |
| **estimation** | Bounded decomposition, reference-class forecasting, explicit ranges and padding | Before committing to effort, time, or cost |
| **skill-authoring** | Gap named with incident, trigger tested against false positives, adversarial pressure-test | Creating or rewriting an agent skill |

## Installation

### Claude Code (plugin — recommended)

```
/plugin marketplace add xD4O/praxis
/plugin install praxis@praxis
```

Restart Claude Code. The router is injected at session start automatically.

### Claude Code (manual)

Skills must be copied **flat** — Claude Code discovers `~/.claude/skills/<name>/SKILL.md`,
not nested directories:

```bash
git clone https://github.com/xD4O/praxis
cp -r praxis/skills/* ~/.claude/skills/
```

Optionally register the session-start hook (plugin installs get this automatically) by
adding to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          { "type": "command", "command": "/absolute/path/to/praxis/hooks/session-start" }
        ]
      }
    ]
  }
}
```

### Other agents and harnesses

Praxis skills follow the open [Agent Skills](https://agentskills.io) format (`SKILL.md`),
supported by Codex, Cursor, VS Code Copilot, Gemini CLI, and others — point your
harness's skills directory at `skills/`. For harnesses without skill support, add the
body of `skills/using-praxis/SKILL.md` to your `AGENTS.md` or system prompt as the router.

### With Superpowers

Install both. They compose automatically — Praxis reasons first, then hands off to Superpowers for TDD, subagent execution, and git workflow.

```
/plugin install superpowers@claude-plugins-official
```

### Verify

Ask for something non-trivial:

```
Help me design a notification service
```

Praxis should activate problem-classification before any work begins. If it doesn't, ask: "What skills do you have access to?" to verify the plugin loaded.

## How it works

A slim router (~100 lines) is injected at session start via a SessionStart hook. It establishes a complexity gate — trivial tasks (fix a typo, rename a variable) skip reasoning entirely — and routes everything else to the matching protocol. Routing is compositional: a task can match several rows (a new security-sensitive feature runs problem-classification *and* security-reasoning, with gap-analysis always last), and three **depth tiers** (QUICK / STANDARD / DEEP) scale the rigor to irreversibility × blast radius, so a gut-check costs a minute while a schema decision gets fresh-context review.

Enforcement is deliberately concentrated instead of spread everywhere: one `<HARD-GATE>` in the router holds three invariants (no final recommendation without gap-analysis, no trust-boundary code without STRIDE, confidence stated on every analysis), and each protocol body keeps its own gates. Two failure modes are designed against explicitly: *skipping* — rationalization-catching names the exact thoughts agents have right before they skip ("I can handle this directly," "this is straightforward enough") and treats them as the signal to route; and *compliance theater* — an anti-theater check requires the agent to name which check actually changed its approach, because filling templates with plausible filler is a protocol violation, not compliance.

The router also handles the two situations rigid protocols get wrong. **User override:** the user is the principal — if they say "skip the analysis," the agent states what's skipped and the concrete risk, offers the QUICK tier, then respects their call. **Autonomous mode:** in headless, CI, or subagent runs where no user can answer, gates that would ask for confirmation instead state their assumptions in writing, cap confidence at MEDIUM, and surface open questions at the end.

## What we learned building it

Six iterations from a passive reference that agents ignored to behavioral enforcement that holds under adversarial pressure:

1. **The description IS the enforcement.** If it reads as a suggestion, the agent skips it.
2. **Sub-skill namespaces don't resolve locally.** `Skill(praxis)` works. `Skill(praxis:sub-name)` doesn't. Sub-protocols load via bash file reads.
3. **HARD-GATEs work — but only after invocation.** The description must compel invocation; body gates are second-line defense.
4. **Agents adapt protocol intensity to context.** Under time pressure, the agent runs compressed STRIDE instead of full ceremony. This is correct behavior.
5. **Handoff instructions must be explicit.** "Superpowers brainstorms with Praxis analysis" (prose) didn't cause handoff. "Invoke Skill(superpowers:brainstorming) NOW" (command) did.

## Philosophy

- **Behavioral enforcement, not reference.** Skills are protocols to follow, not documents to read.
- **Reason before executing.** The approach matters as much as the implementation.
- **Mandatory checkpoints.** HARD-GATEs prevent skipping steps that catch expensive mistakes.
- **Confidence calibration.** Every analysis states its confidence level. Uncertainty is explicit, not hidden.
- **Composability.** Works alone. Works better with Superpowers. Never replaces execution skills.

## Contributing

See [CLAUDE.md](CLAUDE.md) for contributor guidelines. The short version: skills are behavioral protocols, not reference documents. If your PR adds a framework name without building the enforcement protocol, it adds zero value. Show before/after results from real agent sessions.

## License

MIT

---

Built by [@_cyr4x](https://x.com/_cyr4x) · [GitHub](https://github.com/xD4O/praxis)
