# Baby Panda Implementation Plan

> **For Codex:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Port the user's VS Code Baby Panda theme to classic Vim and activate it.

**Architecture:** A self-contained `colors/baby-panda.vim` defines the palette,
editor UI, core groups, and aliases for installed language syntaxes. A matching
Airline palette covers the existing status bar. Existing tests become
theme-selectable and gain targeted token and reload checks.

**Tech Stack:** Vim script, Python standard library, existing terminal-based checks.

1. Create the theme and Airline palette from the installed VS Code source.
2. Make syntax checks select the requested theme and verify that theme survives reload.
3. Add assertions for representative PHP, JSON/YAML, JS, TS, HTML/Twig, spelling,
   UI, and 256-color fallback groups. Resolve syntax-plugin overrides found by tests.
4. Run the fixture suite, real composer.json check, and CSpell UI regression.
5. Inspect a native Kitty preview, activate Baby Panda in `vimrc.local`, and
   update theme documentation. Preserve unrelated files and the fallback theme.
