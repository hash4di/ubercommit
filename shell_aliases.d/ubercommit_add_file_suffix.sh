function ubercommit_add_file_suffix() {
  # shellcheck disable=SC2046
  if [ $(find . -type f -name "*.$1" | wc -l) -gt 0 ]; then
    find "$UBERCOMMIT_PATH/git-hooks" -type f -name "*.rb" | \
      parallel "grep -q \"^#     - '\\*\\*/\\*\\.$1'\" {} && echo {} | sed -e 's|$UBERCOMMIT_PATH/||'" | \
        parallel "test -d .{//} || mkdir -p .{//} ; cp $UBERCOMMIT_PATH/{} .{}" || return $?
    find "$UBERCOMMIT_PATH/git-hooks" -type f -name "*.rb" | \
      parallel "grep -q \"^#     - '\\*\\*/\\*\\.$1'\" {} && echo {}" | \
        parallel 'cat "{}" | grep "^# " | grep -v "^# Example configuration:" | sed -e "s/^# /  /"' \
          1>> .overcommit.yml.example.ubercommit 2>/dev/null
    return $?
  fi
}
