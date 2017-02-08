#!/bin/sh

D_R=`cd \`dirname $0\` ; pwd -P`

which parallel 1>/dev/null 2>/dev/null
if [ $? -gt 0 ]; then
  case `uname` in
    Darwin)
      brew install parallel || return $?
      ;;
    *)
      echo "Please install 'parallel' command"
      exit 1
      ;;
  esac
fi

for PROJECT_DIR in $@
do
  rsync -av $D_R/git-hooks/ $PROJECT_DIR/.git-hooks/ || return $?

  cd $PROJECT_DIR
  for UNTRACKED_FILE in `git st | grep .git-hooks | grep -v "#" | grep "^\?\?" | cut -b4-`
  do
    cat $PROJECT_DIR/.git/info/exclude | grep -q "^$UNTRACKED_FILE$"
    if [ $? -gt 0 ]; then
      echo $UNTRACKED_FILE >> $PROJECT_DIR/.git/info/exclude
    fi
  done
  cd -

  echo 'PreCommit:' > $PROJECT_DIR/.overcommit.yml.example.ubercommit
  find $D_R/git-hooks/ -type f -name "*.rb" | \
    parallel 'cat "{}" | grep "^# " | grep -v "^# Example configuration:" | sed -e "s/^# /  /"' \
    1>> $PROJECT_DIR/.overcommit.yml.example.ubercommit 2>/dev/null
done
