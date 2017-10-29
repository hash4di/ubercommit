function ubercommit_add() {
  if [ -z "$SKIP_EXAMPLES" ]; then
    echo 'PreCommit:' > .overcommit.yml.example.ubercommit
  fi

  parallel \
    "source $UBERCOMMIT_PATH/shell_aliases.d/UBERCOMMIT_PATH.sh && \
     source $UBERCOMMIT_PATH/shell_aliases.d/ubercommit_add_file_suffix.sh && \
     source $UBERCOMMIT_PATH/shell_aliases.d/ubercommit_add_file_suffix_examples.sh && \
     SKIP_EXAMPLES='$SKIP_EXAMPLES' ubercommit_add_file_suffix {}" \
    ::: \
    sh rb && \
      overcommit --sign pre-commit
  return $?
}
