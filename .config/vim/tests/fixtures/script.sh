#!/bin/sh
# POSIX shell quoting, variables, conditions, and command substitution.
name=${1:-Drupal}
if [ -n "$name" ]; then
  printf '%s\n' "Hello $name"
fi
