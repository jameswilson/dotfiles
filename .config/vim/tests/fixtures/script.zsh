#!/bin/zsh
# Zsh arrays, extended globbing, and modifiers.
setopt extendedglob
modules=(drupal fieldblock entity_reference_revisions)
for module in $modules; do
  print -r -- "${module:u}"
done
