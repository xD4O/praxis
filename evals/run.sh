#!/usr/bin/env bash
#
# PRAXIS regression eval harness.
#
# Tests the behavioral claims of skills/using-praxis/SKILL.md (the router)
# headlessly via `claude -p`. For each case in evals/cases/:
#
#   1. Builds the system-prompt injection by running hooks/session-start,
#      so the eval always tests THIS working tree's router — not whatever
#      plugin version happens to be installed.
#   2. Sends the case prompt to a subject run:
#        claude -p "<prompt>" --append-system-prompt "<router body>"
#      (--append-system-prompt verified against `claude -p --help`.)
#   3. Grades the transcript with a second `claude -p` judge call against
#      the case's rubric, demanding a strict JSON verdict.
#
# Isolation choices (deliberate — see README):
#   --tools ""               subject reasons from the injected text only; no
#                            Skill/Read tool, so the installed praxis plugin's
#                            skill files can't be loaded. The subject is TOLD it
#                            has no tools (ENV_NOTE below) — otherwise it attempts
#                            a doomed Read that terminates the -p turn before the
#                            router's inline fallback can fire, an artifact no
#                            real harness has (real harnesses return tool errors).
#                            Cases whose rubric tests sub-skill content may
#                            pre-load routed skill bodies via a '## Skills'
#                            section (one skill name per line) — this mirrors
#                            installs where skills actually load, which is how
#                            the original manual T-tests were run.
#   --disable-slash-commands no skills listed/loadable at all.
#   --settings '{"disableAllHooks":true}'
#                            the installed praxis plugin's own session-start hook
#                            (and any other user hooks) must not double-inject.
#   --strict-mcp-config      no user-configured MCP servers.
#   --no-session-persistence don't litter ~/.claude with eval sessions.
#   cwd = results dir        no project CLAUDE.md gets auto-discovered.
#
# Usage:
#   ./run.sh                 run all cases
#   ./run.sh T2.4            run one case (repeatable: ./run.sh T2.1 T2.4)
#   ./run.sh --list          print case IDs and titles, no model calls
#   ./run.sh --model sonnet  pass a model to both subject and judge calls
#                            (default: whatever `claude` defaults to)
#
# Exit status: 0 if every graded case passed, 1 otherwise, 2 on usage error.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CASES_DIR="$SCRIPT_DIR/cases"
HOOK="$REPO_ROOT/hooks/session-start"
PER_CALL_TIMEOUT="${PRAXIS_EVAL_TIMEOUT:-600}"  # seconds per claude call

usage() {
  sed -n '/^# Usage:/,/^# Exit status/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

# ---------------------------------------------------------------- arg parsing
MODEL=""
LIST=0
SELECTED=()
while [ $# -gt 0 ]; do
  case "$1" in
    --model)
      [ $# -ge 2 ] || { echo "error: --model needs a value" >&2; exit 2; }
      MODEL="$2"; shift 2 ;;
    --model=*)
      MODEL="${1#--model=}"; shift ;;
    --list)
      LIST=1; shift ;;
    -h|--help)
      usage; exit 0 ;;
    T2.*)
      SELECTED+=("$1"); shift ;;
    *)
      echo "error: unknown argument: $1" >&2; usage; exit 2 ;;
  esac
done

# ------------------------------------------------------------------- helpers
# Extract the body of a "## <name>" section from a case file (data-only files;
# all logic lives here). Trims leading/trailing blank lines.
extract_section() { # $1=file $2=section-name
  awk -v sec="$2" '
    /^## /   { inside = ($0 == "## " sec); next }
    inside   { print }
  ' "$1" | python3 -c 'import sys; sys.stdout.write(sys.stdin.read().strip() + "\n")'
}

case_title() { # $1=file — first heading line, without the leading "# "
  sed -n 's/^# //p' "$1" | head -1
}

# Parse the judge's JSON verdict robustly (it may wrap JSON in prose/fences).
# Prints VERDICT:PASS|FAIL|ERROR, then CRITERION:/REASON: lines.
parse_verdict() { # $1=judge-output-file
  python3 - "$1" <<'PY'
import json, sys

text = open(sys.argv[1], encoding="utf-8", errors="replace").read()
dec = json.JSONDecoder()
obj = None
i = text.find("{")
while i != -1:
    try:
        cand, _ = dec.raw_decode(text[i:])
        if isinstance(cand, dict) and "pass" in cand:
            obj = cand
            break
    except json.JSONDecodeError:
        pass
    i = text.find("{", i + 1)

if obj is None:
    print("VERDICT:ERROR")
    sys.exit(0)

print("VERDICT:" + ("PASS" if obj.get("pass") is True else "FAIL"))
for c in obj.get("failed_criteria") or []:
    print("CRITERION:" + " ".join(str(c).split()))
print("REASON:" + " ".join(str(obj.get("reasoning", "")).split()))
PY
}

# ------------------------------------------------------------------ case set
[ -d "$CASES_DIR" ] || { echo "error: no cases dir at $CASES_DIR" >&2; exit 2; }

ALL_CASES=()
while IFS= read -r f; do ALL_CASES+=("$f"); done \
  < <(ls "$CASES_DIR"/T2.*.md 2>/dev/null | sort -V)
[ ${#ALL_CASES[@]} -gt 0 ] || { echo "error: no case files in $CASES_DIR" >&2; exit 2; }

if [ $LIST -eq 1 ]; then
  for f in "${ALL_CASES[@]}"; do
    id="$(basename "$f" .md)"
    printf '%-6s %s\n' "$id" "$(case_title "$f")"
  done
  exit 0
fi

RUN_CASES=()
if [ ${#SELECTED[@]} -eq 0 ]; then
  RUN_CASES=("${ALL_CASES[@]}")
else
  for id in "${SELECTED[@]}"; do
    f="$CASES_DIR/$id.md"
    [ -f "$f" ] || { echo "error: no such case: $id (expected $f)" >&2; exit 2; }
    RUN_CASES+=("$f")
  done
fi

# --------------------------------------------------------------- preflight
command -v claude >/dev/null 2>&1 || { echo "error: claude CLI not on PATH" >&2; exit 2; }
command -v python3 >/dev/null 2>&1 || { echo "error: python3 not on PATH" >&2; exit 2; }
[ -x "$HOOK" ] || { echo "error: $HOOK missing or not executable" >&2; exit 2; }

ROUTER="$("$HOOK")"
[ -n "$ROUTER" ] || { echo "error: hooks/session-start emitted nothing" >&2; exit 2; }

CLAUDE_ARGS=(
  --tools ""
  --disable-slash-commands
  --no-session-persistence
  --strict-mcp-config
  --settings '{"disableAllHooks":true}'
)
[ -n "$MODEL" ] && CLAUDE_ARGS+=(--model "$MODEL")

ENV_NOTE="Environment note: this session has NO tools — you cannot invoke skills, \
read files, or make any tool call, so do not emit tool calls. Protocols pre-loaded \
above (if any) are already fully loaded: apply them as written. Any other protocol \
must be run inline, in this same turn, from what the router says about it."

STAMP="$(date -u +%Y%m%d-%H%M%S)"
RESULTS_DIR="$SCRIPT_DIR/results/$STAMP"
mkdir -p "$RESULTS_DIR"
printf '%s\n' "$ROUTER" > "$RESULTS_DIR/router.txt"

echo "PRAXIS eval run — $STAMP"
echo "router: $HOOK ($(printf '%s\n' "$ROUTER" | wc -l) lines)"
echo "model:  ${MODEL:-<claude default>}"
echo "cases:  ${#RUN_CASES[@]}"
echo "results: $RESULTS_DIR"
echo

# ---------------------------------------------------------------- main loop
FAILED=0
ERRORED=0
SUMMARY=""

for f in "${RUN_CASES[@]}"; do
  id="$(basename "$f" .md)"
  title="$(case_title "$f")"
  case_dir="$RESULTS_DIR/$id"
  mkdir -p "$case_dir"

  prompt="$(extract_section "$f" "Prompt")"
  rubric="$(extract_section "$f" "Rubric")"
  if [ -z "$prompt" ] || [ -z "$rubric" ]; then
    echo "[$id] ERROR — case file is missing a '## Prompt' or '## Rubric' section"
    ERRORED=$((ERRORED + 1)); SUMMARY+="ERROR  $id (malformed case file)\n"
    continue
  fi
  printf '%s\n' "$prompt" > "$case_dir/prompt.txt"
  printf '%s\n' "$rubric" > "$case_dir/rubric.txt"

  # Optional '## Skills' section: pre-load the named skill bodies into the
  # subject's system prompt (frontmatter stripped, same sed as session-start).
  subject_sys="$ROUTER"
  skills_list="$(extract_section "$f" "Skills")"
  if [ -n "$skills_list" ]; then
    while IFS= read -r sk; do
      sk="$(printf '%s' "$sk" | sed 's/^[- ]*//; s/[[:space:]]*$//')"
      [ -z "$sk" ] && continue
      sf="$REPO_ROOT/skills/$sk/SKILL.md"
      if [ -f "$sf" ]; then
        subject_sys+=$'\n\n'"=== PRE-LOADED PROTOCOL: $sk ==="$'\n'"$(sed '1{/^---$/!q;};1,/^---$/d' "$sf")"
      else
        echo "  WARN — case lists unknown skill: $sk"
      fi
    done <<< "$skills_list"
  fi
  subject_sys+=$'\n\n'"$ENV_NOTE"
  printf '%s\n' "$subject_sys" > "$case_dir/system-prompt.txt"

  echo "[$id] $title"
  echo "  subject call..."
  # cwd = results dir so no project CLAUDE.md is auto-discovered into context.
  if ! ( cd "$case_dir" && timeout "$PER_CALL_TIMEOUT" \
        claude -p "$prompt" --append-system-prompt "$subject_sys" "${CLAUDE_ARGS[@]}" \
        > transcript.txt 2> subject.stderr ); then
    echo "  ERROR — subject claude call failed (see $case_dir/subject.stderr)"
    ERRORED=$((ERRORED + 1)); SUMMARY+="ERROR  $id (subject call failed)\n"
    continue
  fi

  judge_prompt="$(cat <<EOF
You are a strict automated grader for a behavioral eval of an AI coding agent.

The agent was given the task prompt below, with a reasoning-methodology router
injected into its system prompt. You are given the agent's full response
transcript and a rubric. Grade the transcript against EVERY rubric criterion.

Rules:
- "pass" is true ONLY if every criterion is clearly satisfied by the transcript itself.
- Default to FAIL when uncertain, when evidence is ambiguous, or when a criterion
  is only arguably met.
- Template-filling without substance FAILS: naming a check, framework, protocol,
  or confidence level without content specific to THIS task does not satisfy any
  criterion about that check. Boilerplate compliance is failure, not compliance.
- Judge only what is in the transcript. Give no credit for what the agent
  probably intended or would have done next.

Respond with ONLY a single JSON object — no markdown fences, no prose before or
after it — in exactly this shape:
{"pass": true, "failed_criteria": ["<number + short name of each failed criterion>"], "reasoning": "<2-4 sentences>"}

=== TASK PROMPT GIVEN TO THE AGENT ===
$prompt

=== AGENT TRANSCRIPT ===
$(cat "$case_dir/transcript.txt")

=== RUBRIC ===
$rubric
EOF
)"
  printf '%s\n' "$judge_prompt" > "$case_dir/judge-prompt.txt"

  echo "  judge call..."
  if ! ( cd "$case_dir" && timeout "$PER_CALL_TIMEOUT" \
        claude -p "$judge_prompt" "${CLAUDE_ARGS[@]}" \
        > judge-output.txt 2> judge.stderr ); then
    echo "  ERROR — judge claude call failed (see $case_dir/judge.stderr)"
    ERRORED=$((ERRORED + 1)); SUMMARY+="ERROR  $id (judge call failed)\n"
    continue
  fi

  verdict_lines="$(parse_verdict "$case_dir/judge-output.txt")"
  printf '%s\n' "$verdict_lines" > "$case_dir/verdict.txt"
  verdict="$(printf '%s\n' "$verdict_lines" | sed -n 's/^VERDICT://p' | head -1)"

  case "$verdict" in
    PASS)
      echo "  PASS"
      SUMMARY+="PASS   $id\n" ;;
    FAIL)
      echo "  FAIL"
      printf '%s\n' "$verdict_lines" | sed -n 's/^CRITERION:/    failed: /p'
      printf '%s\n' "$verdict_lines" | sed -n 's/^REASON:/    judge:  /p'
      FAILED=$((FAILED + 1)); SUMMARY+="FAIL   $id\n" ;;
    *)
      echo "  ERROR — could not parse a JSON verdict (see $case_dir/judge-output.txt)"
      ERRORED=$((ERRORED + 1)); SUMMARY+="ERROR  $id (unparseable verdict)\n" ;;
  esac
  echo
done

# ------------------------------------------------------------------ summary
echo "==============================="
printf "$SUMMARY"
echo "==============================="
total=${#RUN_CASES[@]}
passed=$((total - FAILED - ERRORED))
echo "passed $passed / $total  (failed: $FAILED, errored: $ERRORED)"
echo "transcripts: $RESULTS_DIR"

[ $((FAILED + ERRORED)) -eq 0 ] || exit 1
exit 0
