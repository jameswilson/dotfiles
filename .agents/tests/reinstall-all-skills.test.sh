#!/usr/bin/env bash
set -euo pipefail

SCRIPT="/Users/jameswilson/.agents/reinstall-all-skills.sh"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_contains() {
  local needle="$1"
  local file="$2"

  if ! grep -Fq -- "$needle" "$file"; then
    echo "Expected to find: $needle" >&2
    echo "--- $file ---" >&2
    cat "$file" >&2
    fail "missing expected text"
  fi
}

assert_not_contains() {
  local needle="$1"
  local file="$2"

  if grep -Fq -- "$needle" "$file"; then
    echo "Did not expect to find: $needle" >&2
    echo "--- $file ---" >&2
    cat "$file" >&2
    fail "found unexpected text"
  fi
}

assert_exists() {
  local path="$1"
  [[ -e "$path" ]] || fail "expected path to exist: $path"
}

assert_not_exists() {
  local path="$1"
  [[ ! -e "$path" ]] || fail "expected path to be absent: $path"
}

create_test_env() {
  local root
  root="$(mktemp -d)"
  local home="$root/home"
  local bin="$root/bin"

  mkdir -p "$home/.agents" "$bin"

  cat > "$home/.agents/.skill-lock.json" <<'EOF'
{
  "version": 3,
  "skills": {
    "find-skills": {
      "source": "vercel-labs/skills",
      "sourceType": "github",
      "sourceUrl": "https://github.com/vercel-labs/skills.git",
      "skillPath": "skills/find-skills/SKILL.md",
      "skillFolderHash": "abc123",
      "installedAt": "2026-01-26T23:06:01.293Z",
      "updatedAt": "2026-01-26T23:16:50.431Z"
    },
    "frontend-design": {
      "source": "anthropics/skills",
      "sourceType": "github",
      "sourceUrl": "https://github.com/anthropics/skills.git",
      "skillPath": "frontend-design/SKILL.md",
      "skillFolderHash": "def456",
      "installedAt": "2026-01-26T23:06:01.293Z",
      "updatedAt": "2026-01-26T23:16:50.431Z"
    }
  }
}
EOF

  cat > "$bin/npx" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' "$*" >> "${NPX_LOG:?}"

if [[ "${1:-}" == "-y" ]]; then
  shift
fi

[[ "${1:-}" == "skills" ]] || exit 0
shift

case "${1:-}" in
  add|check)
    exit 0
    ;;
  *)
    echo "unexpected npx command: $*" >&2
    exit 64
    ;;
esac
EOF
  chmod +x "$bin/npx"

  printf '%s\n' "$root"
}

run_script() {
  local root="$1"
  shift

  local home="$root/home"
  local bin="$root/bin"
  local stdout_file="$root/stdout"
  local stderr_file="$root/stderr"

  NPX_LOG="$root/npx.log" \
  HOME="$home" \
  PATH="$bin:$PATH" \
  "$SCRIPT" "$@" >"$stdout_file" 2>"$stderr_file"
}

test_requires_agent_argument() {
  local root
  root="$(create_test_env)"

  if run_script "$root"; then
    fail "script should fail when no agent is supplied"
  fi

  assert_contains "Usage:" "$root/stderr"
  assert_contains "--agent" "$root/stderr"
  [[ ! -f "$root/npx.log" ]] || fail "npx should not run before argument validation"
}

test_dry_run_skips_execution() {
  local root
  root="$(create_test_env)"

  run_script "$root" --agent codex --dry-run

  assert_contains "Dry run" "$root/stdout"
  assert_contains "vercel-labs/skills" "$root/stdout"
  assert_contains "--agent codex" "$root/stdout"
  [[ ! -f "$root/npx.log" ]] || fail "dry-run should not execute npx"
}

test_prune_only_selected_agent_paths() {
  local root
  root="$(create_test_env)"
  local home="$root/home"

  mkdir -p \
    "$home/.codex/skills/find-skills" \
    "$home/.codex/skills/keep-me" \
    "$home/.codex/skills/frontend-design" \
    "$home/.claude/skills/find-skills"

  run_script "$root" --agent codex --prune

  assert_not_exists "$home/.codex/skills/find-skills"
  assert_not_exists "$home/.codex/skills/frontend-design"
  assert_exists "$home/.codex/skills/keep-me"
  assert_exists "$home/.claude/skills/find-skills"
  assert_contains "skills add vercel-labs/skills -g -y --agent codex --skill find-skills" "$root/npx.log"
  assert_contains "skills add anthropics/skills -g -y --agent codex --skill frontend-design" "$root/npx.log"
  assert_not_contains "remove --all" "$root/npx.log"
}

main() {
  test_requires_agent_argument
  test_dry_run_skips_execution
  test_prune_only_selected_agent_paths
  echo "PASS: reinstall-all-skills"
}

main "$@"
