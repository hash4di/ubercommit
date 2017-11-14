function ubercommit_add_file_suffix() {
  # shellcheck disable=SC2046,SC2126
  if [ $(find . -type f -name "*.$1" | grep -v "^./.git-hooks/" | wc -l) -gt 0 ]; then
    find "$UBERCOMMIT_PATH/git-hooks" -type f -name "*.rb" | \
      parallel "grep -q \"^#     - '.*/\\*\\.$1'\" {} && echo {} | sed -e 's|$UBERCOMMIT_PATH/||'" | \
        parallel "test -d .{//} || mkdir -p .{//} ; cp $UBERCOMMIT_PATH/{} .{}" || return $?
    if [ -z "$SKIP_EXAMPLES" ]; then
      ubercommit_add_file_suffix_examples "$1" || return $?
    fi
  fi
}
