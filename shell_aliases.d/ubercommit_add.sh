function ubercommit_add() {
  local ubercommit_add_COMMAND_DEPENDENCIES
  ubercommit_add_COMMAND_DEPENDENCIES="source $UBERCOMMIT_PATH/shell_aliases.d/UBERCOMMIT_PATH.sh"
  ubercommit_add_COMMAND_DEPENDENCIES+=" && source $UBERCOMMIT_PATH/shell_aliases.d/ubercommit_add_file_suffix.sh"

  echo 'PreCommit:' > .overcommit.yml.example.ubercommit

  parallel \
    "$ubercommit_add_COMMAND_DEPENDENCIES && ubercommit_add_file_suffix {}" \
    ::: \
    sh rb && \
      overcommit --sign pre-commit
  return $?
}
