#!/bin/bash

D_R=$(cd "$(dirname "$0")" || exit 1; pwd -P)

if ! (which parallel 1>/dev/null 2>/dev/null); then
  case $(uname) in
    Darwin)
      brew install parallel || return $?
      ;;
    *)
      echo "Please install 'parallel' command"
      exit 1
      ;;
  esac
fi

# shellcheck disable=SC1090
source "$D_R/shell_aliases.d/UBERCOMMIT_PATH.sh" || return $?
# shellcheck disable=SC1090
source "$D_R/shell_aliases.d/ubercommit_add.sh" || return $?
# shellcheck disable=SC1090
source "$D_R/shell_aliases.d/ubercommit_add_file_suffix.sh" || return $?

for PROJECT_DIR in "$@"
do
  cd "$PROJECT_DIR" || exit $?

  ubercommit_add || return $?

  git st | grep .git-hooks | grep -v "#" | grep "^\?\?" | cut -b4- | \
    parallel \
      -j 1 \
      "grep -q {} $PROJECT_DIR/.git/info/exclude || echo {} >> $PROJECT_DIR/.git/info/exclude"

  cd - || exit $?
done
