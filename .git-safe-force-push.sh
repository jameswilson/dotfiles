#!/bin/bash
# echo ~/.git-safe-force-push.sh
# Replace `git push --force` with `git push --force-with-lease --force-if-includes`
git() {
  if [[ $@ == 'push -f'* || $@ == 'push --force'* ]]; then
    echo "--force has been replaced with safer --force-with-lease --force-if-includes"
    echo "See ~/.gitforcepushwithlease"
    command git push --force-with-lease --force-if-includes
  else
    command git "$@"
  fi
}
