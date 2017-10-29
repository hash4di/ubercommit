function ubercommit_full_setup() {
  ubercommit_add || return $?
  cp ../common_shell_aliases/.overcommit.yml . || return $?
  overcommit || return $?
  overcommit --sign || return $?
  overcommit --sign pre-commit || return $?
  rm .overcommit.yml.example.ubercommit || return $?
  git add .overcommit.yml .git-hooks/ || return $?
  git commit -a -m "Add overcommit and ubercommit checks" || return $?
}
