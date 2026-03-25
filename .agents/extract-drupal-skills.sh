#!/usr/bin/env bash
# Extract drupal-related skills from .skill-lock.json and regenerate drupal-skills.md.
#
# Usage: ./extract-drupal-skills.sh [path-to-skill-lock.json] [path-to-output-md]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCK_FILE="${1:-${SCRIPT_DIR}/.skill-lock.json}"
OUTPUT_FILE="${2:-${SCRIPT_DIR}/drupal-skills.md}"
TEMP_FILE="$(mktemp)"

cleanup() {
  rm -f "$TEMP_FILE"
}

trap cleanup EXIT

if [[ ! -f "$LOCK_FILE" ]]; then
  echo "Error: $LOCK_FILE not found" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required. Install with: brew install jq" >&2
  exit 1
fi

table_rows="$(jq -r '
  .skills | to_entries |
  map(select(.key | test("drupal|drupalorg|ddev|cursorrules-drupal|http-cache"))) |
  group_by(.value.sourceUrl) |
  map({
    url: (.[0].value.sourceUrl | sub("\\.git$"; "")),
    skills: (map(.key) | join(", "))
  }) |
  map("| \(.url) | \(.skills) |") |
  join("\n")
' "$LOCK_FILE")"

cat >"$TEMP_FILE" <<EOF
# Drupal-related skills

Extracted from \`.skill-lock.json\` in this directory.

## Table

| Repository | Skills |
|------------|--------|
${table_rows}

## How to regenerate

Run the extraction script from this directory:

\`\`\`bash
cd ~/.agents
./extract-drupal-skills.sh
\`\`\`

Or with a custom path to \`skill-lock.json\`:

\`\`\`bash
./extract-drupal-skills.sh /path/to/.skill-lock.json
\`\`\`

**Requires:** \`jq\` (install via \`brew install jq\` on macOS)
EOF

mv "$TEMP_FILE" "$OUTPUT_FILE"
echo "Regenerated $OUTPUT_FILE"
