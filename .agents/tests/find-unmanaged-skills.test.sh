#!/usr/bin/env bash
set -euo pipefail

SCRIPT="/Users/jameswilson/.agents/find-unmanaged-skills.sh"

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

create_test_env() {
  local root
  root="$(mktemp -d)"
  local home="$root/home"

  mkdir -p "$home/.agents"

  cat > "$home/.agents/.skill-lock.json" <<'EOF'
{
  "version": 3,
  "skills": {
    "locked-skill": {
      "source": "example/repo",
      "sourceType": "github",
      "sourceUrl": "https://github.com/example/repo.git",
      "skillPath": "locked-skill/SKILL.md",
      "skillFolderHash": "aaa",
      "installedAt": "2026-01-26T23:06:01.293Z",
      "updatedAt": "2026-01-26T23:16:50.431Z"
    },
    "nested-locked": {
      "source": "example/repo",
      "sourceType": "github",
      "sourceUrl": "https://github.com/example/repo.git",
      "skillPath": ".system/nested-locked/SKILL.md",
      "skillFolderHash": "bbb",
      "installedAt": "2026-01-26T23:06:01.293Z",
      "updatedAt": "2026-01-26T23:16:50.431Z"
    }
  }
}
EOF

  printf '%s\n' "$root"
}

run_script() {
  local root="$1"
  shift

  HOME="$root/home" \
  bash "$SCRIPT" "$@" >"$root/stdout" 2>"$root/stderr"
}

test_reports_unmanaged_skills_at_expected_depths() {
  local root
  root="$(create_test_env)"
  local home="$root/home"

  mkdir -p \
    "$home/.codex/skills/locked-skill" \
    "$home/.codex/skills/unmanaged-top" \
    "$home/.codex/skills/.system/nested-locked" \
    "$home/.codex/skills/.system/unmanaged-system" \
    "$home/.claude/skills/superpowers/skills/unmanaged-superpower"

  touch \
    "$home/.codex/skills/locked-skill/SKILL.md" \
    "$home/.codex/skills/unmanaged-top/SKILL.md" \
    "$home/.codex/skills/.system/nested-locked/SKILL.md" \
    "$home/.codex/skills/.system/unmanaged-system/SKILL.md" \
    "$home/.claude/skills/superpowers/skills/unmanaged-superpower/SKILL.md"

  if run_script "$root"; then
    fail "script should exit nonzero when unmanaged skills are found"
  fi

  assert_contains "Unmanaged skills found: 3" "$root/stdout"
  assert_contains "codex" "$root/stdout"
  assert_contains "claude-code" "$root/stdout"
  assert_contains "unmanaged-top" "$root/stdout"
  assert_contains "unmanaged-system" "$root/stdout"
  assert_contains "unmanaged-superpower" "$root/stdout"
  assert_not_contains "locked-skill" "$root/stdout"
  assert_not_contains "nested-locked" "$root/stdout"
}

test_ignores_skill_md_outside_expected_layout_depths() {
  local root
  root="$(create_test_env)"
  local home="$root/home"

  mkdir -p \
    "$home/.codex/skills/deep/tree/too-deep/ignored" \
    "$home/.codex/skills/random"

  touch \
    "$home/.codex/skills/deep/tree/too-deep/ignored/SKILL.md" \
    "$home/.codex/skills/random/README.md"

  run_script "$root"

  assert_contains "No unmanaged skills found." "$root/stdout"
}

test_json_output() {
  local root
  root="$(create_test_env)"
  local home="$root/home"

  mkdir -p "$home/.cursor/skills/unmanaged-json"
  touch "$home/.cursor/skills/unmanaged-json/SKILL.md"

  if run_script "$root" --json; then
    fail "json output should still exit nonzero when unmanaged skills are found"
  fi

  assert_contains '"skill": "unmanaged-json"' "$root/stdout"
  assert_contains '"agent": "cursor"' "$root/stdout"
}

test_suppresses_mirrored_managed_copies() {
  local root
  root="$(create_test_env)"
  local home="$root/home"

  mkdir -p \
    "$home/.agents/skills/audit-website" \
    "$home/.agents/skills/superpowers/skills/test-driven-development" \
    "$home/.agents/skills/skill-creator" \
    "$home/.claude/skills/audit-website" \
    "$home/.claude/skills/superpowers/skills/test-driven-development" \
    "$home/.codex/skills/.system/skill-creator"

  cat > "$home/.agents/skills/audit-website/SKILL.md" <<'EOF'
---
name: audit-website
description: Managed mirror
---
EOF

  cp "$home/.agents/skills/audit-website/SKILL.md" "$home/.claude/skills/audit-website/SKILL.md"

  cat > "$home/.agents/skills/superpowers/skills/test-driven-development/SKILL.md" <<'EOF'
---
name: test-driven-development
description: Managed nested mirror
---
EOF

  cp \
    "$home/.agents/skills/superpowers/skills/test-driven-development/SKILL.md" \
    "$home/.claude/skills/superpowers/skills/test-driven-development/SKILL.md"

  cat > "$home/.agents/skills/skill-creator/SKILL.md" <<'EOF'
---
name: skill-creator
description: Generic creator
---
EOF

  cat > "$home/.codex/skills/.system/skill-creator/SKILL.md" <<'EOF'
---
name: skill-creator
description: System creator
---
EOF

  if run_script "$root"; then
    fail "script should still report unmatched system skill"
  fi

  assert_not_contains "audit-website" "$root/stdout"
  assert_not_contains "test-driven-development" "$root/stdout"
  assert_contains "skill-creator" "$root/stdout"
  assert_contains ".system/skill-creator" "$root/stdout"
}

main() {
  test_reports_unmanaged_skills_at_expected_depths
  test_ignores_skill_md_outside_expected_layout_depths
  test_json_output
  test_suppresses_mirrored_managed_copies
  echo "PASS: find-unmanaged-skills"
}

main "$@"
