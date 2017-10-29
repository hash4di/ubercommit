function ubercommit_add_file_suffix_examples() {
  # shellcheck disable=SC2046,SC2126
  if [ $(find . -type f -name "*.$1" | grep -v "^./.git-hooks/" | wc -l) -gt 0 ]; then
    find "$UBERCOMMIT_PATH/git-hooks" -type f -name "*.rb" | \
      parallel "grep -q \"^#     - '\\*\\*/\\*\\.$1'\" {} && echo {}" | \
        parallel 'cat "{}" | grep "^# " | grep -v "^# Example configuration:" | sed -e "s/^# /  /"' \
          1>> .overcommit.yml.example.ubercommit 2>/dev/null
    return $?
  fi
}
