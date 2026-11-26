# Shared Drupal spelling vocabulary

These are copies of Drupal core's `misc/cspell/drupal-dictionary.txt` and
`misc/cspell/dictionary.txt`, recovered from the local IULD8 Drupal 10.6.23 installation
on 2026-11-26. The accompanying upstream GPL license is in `LICENSE.txt`.

Canonical sources:

- https://git.drupalcode.org/project/drupal/-/blob/11.x/core/misc/cspell/drupal-dictionary.txt
- https://git.drupalcode.org/project/drupal/-/blob/11.x/core/misc/cspell/dictionary.txt

The checker prefers a detected project's own Drupal core lists, keeping its
vocabulary aligned with the installed core version. These shared copies are the
fallback for other files. Refresh the copies from a reviewed Drupal core update
and commit the changed lists when desired. Project-specific words belong in the
project's CSpell configuration or a dictionary it imports.
