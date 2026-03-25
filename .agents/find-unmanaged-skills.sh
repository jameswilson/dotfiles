#!/usr/bin/env bash
# Scan known global agent skill directories for skills not present in ~/.agents/.skill-lock.json.

set -euo pipefail

LOCK_FILE="${HOME}/.agents/.skill-lock.json"
MANAGED_SKILLS_ROOT="${HOME}/.agents/skills"
JSON_OUTPUT=0

usage() {
  cat >&2 <<'EOF'
Usage: find-unmanaged-skills.sh [--json]

Scan known global agent skill directories for SKILL.md files that resolve to skill names
not present in ~/.agents/.skill-lock.json.

Options:
  --json   Emit JSON instead of plain text.
  --help   Show this help text.
EOF
}

die() {
  echo "$*" >&2
  exit 2
}

parse_args() {
  while (( $# > 0 )); do
    case "$1" in
      --json)
        JSON_OUTPUT=1
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
}

validate_prereqs() {
  command -v jq >/dev/null 2>&1 || die "jq required (brew install jq)"
  [[ -f "$LOCK_FILE" ]] || die "No lock file at $LOCK_FILE"
}

agent_roots() {
  cat <<EOF
amp|${HOME}/.config/agents/skills
antigravity|${HOME}/.gemini/antigravity/skills
claude-code|${HOME}/.claude/skills
clawdbot|${HOME}/.clawdbot/skills
cline|${HOME}/.cline/skills
codex|${HOME}/.codex/skills
command-code|${HOME}/.commandcode/skills
cursor|${HOME}/.cursor/skills
droid|${HOME}/.factory/skills
gemini-cli|${HOME}/.gemini/skills
github-copilot|${HOME}/.copilot/skills
goose|${HOME}/.config/goose/skills
kilo|${HOME}/.kilocode/skills
kiro-cli|${HOME}/.kiro/skills
neovate|${HOME}/.neovate/skills
opencode|${HOME}/.config/opencode/skills
openhands|${HOME}/.openhands/skills
pi|${HOME}/.pi/agent/skills
qoder|${HOME}/.qoder/skills
roo|${HOME}/.roo/skills
trae|${HOME}/.trae/skills
windsurf|${HOME}/.codeium/windsurf/skills
zencoder|${HOME}/.zencoder/skills
EOF
}

find_skill_files() {
  local root="$1"
  local skill_file rel_path rel_without_file depth

  while IFS= read -r skill_file; do
    [[ -n "$skill_file" ]] || continue

    rel_path="${skill_file#"$root"/}"
    rel_without_file="${rel_path%/SKILL.md}"

    if [[ "$rel_without_file" == "$rel_path" ]]; then
      continue
    fi

    depth="$(awk -F'/' '{print NF}' <<< "$rel_path")"
    if [[ "$depth" == "2" || "$depth" == "3" || "$depth" == "4" ]]; then
      printf '%s\n' "$skill_file"
    fi
  done < <(find "$root" -type f -name SKILL.md -print 2>/dev/null)
}

is_managed_mirror() {
  local root="$1"
  local skill_file="$2"
  local skill_dir rel_dir mirror_dir

  [[ -d "$MANAGED_SKILLS_ROOT" ]] || return 1

  skill_dir="$(dirname "$skill_file")"
  rel_dir="${skill_dir#"$root"/}"
  [[ "$rel_dir" != "$skill_dir" ]] || return 1

  mirror_dir="${MANAGED_SKILLS_ROOT}/${rel_dir}"
  [[ -d "$mirror_dir" ]] || return 1

  diff -qr "$skill_dir" "$mirror_dir" >/dev/null 2>&1
}

scan_unmanaged() {
  local results_file="$1"
  : > "$results_file"

  local roots_file
  roots_file="$(mktemp)"
  jq -r '.skills | keys[]' "$LOCK_FILE" | sort -u > "$roots_file"

  local row agent root skill_file skill_name
  while IFS='|' read -r agent root; do
    [[ -d "$root" ]] || continue

    while IFS= read -r skill_file; do
      [[ -n "$skill_file" ]] || continue
      skill_name="$(basename "$(dirname "$skill_file")")"

      if ! grep -Fqx -- "$skill_name" "$roots_file"; then
        if is_managed_mirror "$root" "$skill_file"; then
          continue
        fi
        printf '%s\t%s\t%s\t%s\n' "$agent" "$root" "$skill_name" "$skill_file" >> "$results_file"
      fi
    done < <(find_skill_files "$root")
  done < <(agent_roots)

  sort -u -o "$results_file" "$results_file"
  rm -f "$roots_file"
}

print_text_report() {
  local results_file="$1"
  local count
  count="$(wc -l < "$results_file" | tr -d ' ')"

  if [[ "$count" == "0" ]]; then
    echo "No unmanaged skills found."
    return 0
  fi

  echo "Unmanaged skills found: $count"
  echo

  local current_agent=""
  local agent root skill_name skill_file
  while IFS=$'\t' read -r agent root skill_name skill_file; do
    if [[ "$agent" != "$current_agent" ]]; then
      [[ -z "$current_agent" ]] || echo
      echo "$agent ($root)"
      current_agent="$agent"
    fi
    echo "  - $skill_name: $skill_file"
  done < "$results_file"
}

print_json_report() {
  local results_file="$1"

  jq -Rn '
    [inputs
      | select(length > 0)
      | split("\t")
      | {
          agent: .[0],
          root: .[1],
          skill: .[2],
          skill_file: .[3]
        }
    ]
  ' < "$results_file"
}

main() {
  parse_args "$@"
  validate_prereqs

  local results_file
  results_file="$(mktemp)"
  trap 'rm -f -- "${results_file:-}"' EXIT

  scan_unmanaged "$results_file"

  if (( JSON_OUTPUT )); then
    print_json_report "$results_file"
  else
    print_text_report "$results_file"
  fi

  if [[ -s "$results_file" ]]; then
    exit 1
  fi
}

main "$@"
