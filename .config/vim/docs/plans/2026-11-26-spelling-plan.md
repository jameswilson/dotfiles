# Vim Spelling Implementation Plan

> **For Codex:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Restore readable syntax and add project-aware CSpell with Drupal vocabulary.

**Architecture:** Retain the current Vim/One Monokai setup. Use an isolated,
pinned CSpell engine through an asynchronous Vim job, with location-list results
and underlines that preserve syntax colors.

**Tech Stack:** Vim 9, Vim script, Node.js, CSpell, Python standard library tests.

## Tasks

1. Commit the already-staged migration, preserving the unstaged spelling fix.
2. Update `vimrc.local` and the theme's four spelling groups; remove backed-up
   stale spell flags from saved views. Verify the exact IULD8 composer.json.
3. Add `tests/fixtures`, a manifest, `tests/check-syntax.vim`, `tests/check.py`,
   and `tests/review.vim`. Verify normal Vim and vi startup across the manifest.
4. Add pinned `cspell/package.json` and lockfile, a setup script, Node bridge,
   `autoload/cspell.vim`, and `plugin/cspell.vim`. Test missing dependencies,
   project configs/imports, ignored files, Drupal terms, and real typos.
5. Test save-triggered asynchronous results, location lists, and foreground-free,
   background-free highlights. Verify fixture syntax survives the integration.
6. Write usage instructions, review the exact diff, and create the spelling
   follow-up commit. Leave unrelated home-repository files untouched.

Success requires passing automated fixtures, unchanged project files, and two
separate commits. No push is requested.
