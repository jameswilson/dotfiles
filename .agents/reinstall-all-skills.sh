#!/usr/bin/env bash
# Reinstall only the skills listed in ~/.agents/.skill-lock.json.
# This script only manages global installs and requires explicit target agents.

set -euo pipefail

LOCK_FILE="${HOME}/.agents/.skill-lock.json"
DRY_RUN=0
PRUNE=0
AGENTS=()

usage() {
  cat >&2 <<'EOF'
Usage: reinstall-all-skills.sh --agent <name> [--agent <name> ...] [--dry-run] [--prune]

Reinstall the skills listed in ~/.agents/.skill-lock.json for the selected global agents.

Options:
  --agent <name>   Target agent to reinstall to. Repeat for multiple agents.
  --dry-run        Print the planned prune/install commands without executing them.
  --prune          Remove lock-managed skills from selected agent paths before reinstalling.
  --help           Show this help text.

Examples:
  reinstall-all-skills.sh --agent codex
  reinstall-all-skills.sh --agent codex --agent cursor --prune
  reinstall-all-skills.sh --agent claude-code --dry-run
EOF
}

die() {
  echo "$*" >&2
  exit 1
}

format_cmd() {
  local formatted=""
  local part

  for part in "$@"; do
    formatted+=" $(printf '%q' "$part")"
  done

  printf '%s\n' "${formatted# }"
}

run_cmd() {
  if (( DRY_RUN )); then
    echo "DRY RUN: $(format_cmd "$@")"
    return 0
  fi

  "$@"
}

agent_global_dir() {
  case "$1" in
    amp) echo "${HOME}/.config/agents/skills" ;;
    antigravity) echo "${HOME}/.gemini/antigravity/skills" ;;
    claude-code) echo "${HOME}/.claude/skills" ;;
    clawdbot) echo "${HOME}/.clawdbot/skills" ;;
    cline) echo "${HOME}/.cline/skills" ;;
    codex) echo "${HOME}/.codex/skills" ;;
    command-code) echo "${HOME}/.commandcode/skills" ;;
    cursor) echo "${HOME}/.cursor/skills" ;;
    droid) echo "${HOME}/.factory/skills" ;;
    gemini-cli) echo "${HOME}/.gemini/skills" ;;
    github-copilot) echo "${HOME}/.copilot/skills" ;;
    goose) echo "${HOME}/.config/goose/skills" ;;
    kilo) echo "${HOME}/.kilocode/skills" ;;
    kiro-cli) echo "${HOME}/.kiro/skills" ;;
    neovate) echo "${HOME}/.neovate/skills" ;;
    opencode) echo "${HOME}/.config/opencode/skills" ;;
    openhands) echo "${HOME}/.openhands/skills" ;;
    pi) echo "${HOME}/.pi/agent/skills" ;;
    qoder) echo "${HOME}/.qoder/skills" ;;
    roo) echo "${HOME}/.roo/skills" ;;
    trae) echo "${HOME}/.trae/skills" ;;
    windsurf) echo "${HOME}/.codeium/windsurf/skills" ;;
    zencoder) echo "${HOME}/.zencoder/skills" ;;
    *)
      return 1
      ;;
  esac
}

parse_args() {
  while (( $# > 0 )); do
    case "$1" in
      --agent)
        shift
        [[ $# -gt 0 ]] || die "Missing value for --agent"$'\n'"$(usage)"
        AGENTS+=("$1")
        ;;
      --dry-run)
        DRY_RUN=1
        ;;
      --prune)
        PRUNE=1
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        usage
        die "Unknown argument: $1"
        ;;
    esac
    shift
  done

  (( ${#AGENTS[@]} > 0 )) || {
    usage
    die "At least one --agent is required."
  }
}

validate_prereqs() {
  command -v jq >/dev/null 2>&1 || die "jq required (brew install jq)"
  command -v npx >/dev/null 2>&1 || die "npx required"
  [[ -f "$LOCK_FILE" ]] || die "No lock file at $LOCK_FILE"

  local agent
  for agent in "${AGENTS[@]}"; do
    agent_global_dir "$agent" >/dev/null || die "Unsupported agent: $agent"
  done
}

total_skill_count() {
  jq -r '.skills | length' "$LOCK_FILE"
}

source_group_lines() {
  jq -r '
    .skills
    | to_entries
    | group_by(.value.source)
    | .[]
    | ([.[0].value.source] + (map(.key))) | @tsv
  ' "$LOCK_FILE"
}

managed_skill_names() {
  jq -r '.skills | keys[]' "$LOCK_FILE"
}

print_summary() {
  local source_count
  source_count="$(source_group_lines | grep -c . || true)"

  echo "=== Reinstall plan ==="
  echo "Lock file: $LOCK_FILE"
  echo "Agents: ${AGENTS[*]}"
  echo "Managed skills: $(total_skill_count)"
  echo "Sources: $source_count"
  echo "Prune managed paths first: $([[ $PRUNE -eq 1 ]] && echo yes || echo no)"
  echo "Dry run: $([[ $DRY_RUN -eq 1 ]] && echo yes || echo no)"
  echo

  echo "=== Skills by source ==="
  local line
  while IFS=$'\t' read -r line; do
    [[ -n "$line" ]] || continue
    local fields=()
    IFS=$'\t' read -r -a fields <<< "$line"
    local source="${fields[0]}"
    unset 'fields[0]'
    echo "  $source (${#fields[@]}): ${fields[*]}"
  done < <(source_group_lines)
  echo
}

prune_managed_skills() {
  (( PRUNE )) || return 0

  echo "=== Pruning selected agent paths ==="

  local agent agent_dir skill skill_dir
  for agent in "${AGENTS[@]}"; do
    agent_dir="$(agent_global_dir "$agent")"
    echo "Agent $agent: $agent_dir"

    while IFS= read -r skill; do
      [[ -n "$skill" ]] || continue
      [[ "$skill" != */* ]] || die "Refusing to prune non-canonical skill name: $skill"
      skill_dir="${agent_dir}/${skill}"

      if [[ -e "$skill_dir" ]]; then
        run_cmd rm -rf -- "$skill_dir"
      fi
    done < <(managed_skill_names)
  done

  echo
}

install_source_groups() {
  echo "=== Reinstalling skills ==="

  local line
  while IFS=$'\t' read -r line; do
    [[ -n "$line" ]] || continue

    local fields=()
    IFS=$'\t' read -r -a fields <<< "$line"
    local source="${fields[0]}"
    unset 'fields[0]'
    local skills=("${fields[@]}")

    echo "Adding $source: ${skills[*]}"
    run_cmd npx -y skills add "$source" -g -y --agent "${AGENTS[@]}" --skill "${skills[@]}"
  done < <(source_group_lines)

  echo
}

main() {
  parse_args "$@"
  validate_prereqs

  if [[ "$(total_skill_count)" == "0" ]]; then
    echo "No skills in lock file"
    exit 0
  fi

  print_summary
  prune_managed_skills
  install_source_groups

  if (( DRY_RUN )); then
    echo "Dry run complete. No changes were made."
  else
    echo "Done. Run npx skills check to verify."
  fi
}

main "$@"
