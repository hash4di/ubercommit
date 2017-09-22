#!/bin/sh

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

for PROJECT_DIR in "$@"
do
  rsync -av "$D_R/git-hooks/" "$PROJECT_DIR/.git-hooks/" || return $?

  cd "$PROJECT_DIR" || exit $?
  git st | grep .git-hooks | grep -v "#" | grep "^\?\?" | cut -b4- | \
    parallel \
      -j 1 \
      "grep -q {} $PROJECT_DIR/.git/info/exclude || echo {} >> $PROJECT_DIR/.git/info/exclude"
  cd - || exit $?

  echo 'PreCommit:' > "$PROJECT_DIR/.overcommit.yml.example.ubercommit"
  find "$D_R/git-hooks/" -type f -name "*.rb" | \
    parallel 'cat "{}" | grep "^# " | grep -v "^# Example configuration:" | sed -e "s/^# /  /"' \
    1>> "$PROJECT_DIR/.overcommit.yml.example.ubercommit" 2>/dev/null
done
