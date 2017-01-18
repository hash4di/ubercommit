#!/bin/sh

D_R=`cd \`dirname $0\` ; pwd -P`


for PROJECT_DIR in $@
do
  rsync -av $D_R/git-hooks/ $PROJECT_DIR/.git-hooks/ || return $?

  cd $PROJECT_DIR || return $?
  for UNTRACKED_FILE in `git st | grep -v "#" | grep "^\?\?" | cut -b4-`
  do
    echo $UNTRACKED_FILE >> .git/info/exclude
  done
done
