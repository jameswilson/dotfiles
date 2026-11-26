#!/usr/bin/env bash
# Bash arrays and parameter expansion.
modules=(drupal fieldblock entity_reference_revisions)
for module in "${modules[@]}"; do
  printf '%s\n' "${module^^}"
done
