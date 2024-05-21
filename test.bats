#!/usr/bin/env bats
# shellcheck disable=2030,2031

setup_file() {
  bats_require_minimum_version 1.5.0
}

@test 'refs/heads/main=main' {
  run bin/program-version refs/heads/main
  [ "$output" = "main" ]
}

@test 'refs/heads/master=master' {
  run bin/program-version refs/heads/master
  [ "$output" = "master" ]
}

@test 'refs/heads/ft-refactor=ft-refactor' {
  run bin/program-version refs/heads/ft-refactor
  [ "$output" = "ft-refactor" ]
}

@test 'refs/tags/v1.0.3=v1.0.3' {
  run bin/program-version refs/tags/v1.0.3
  [ "$output" = "v1.0.3" ]
}

@test 'refs/tags/1.0.3=v1.0.3' {
  run bin/program-version refs/tags/1.0.3
  [ "$output" = "v1.0.3" ]
}

@test 'refs/tags/very-pinned=very-pinned' {
  run bin/program-version refs/tags/very-pinned
  [ "$output" = "very-pinned" ]
}

@test 'refs/tags/f1.0.3=f1.0.3' {
  run bin/program-version refs/tags/f1.0.3
  [ "$output" = "f1.0.3" ]
}

@test 'refs/tags/v=v' {
  run bin/program-version refs/tags/v
  [ "$output" = "v" ]
}

@test 'e02d09699ffb56440f34cb7448a0bc436e3ae212=e02d0969' {
  run bin/program-version e02d09699ffb56440f34cb7448a0bc436e3ae212
  [ "$output" = "e02d0969" ]
}

@test 'e02d09699ffb56440f34cb7448=error' {
  run -1 bin/program-version e02d09699ffb56440f34cb7448
}

@test 'master=error' {
  run -1 bin/program-version master
}

@test 'v1.0.3=error' {
  run -1 bin/program-version v1.0.3
}

@test 'refs/heads=error' {
  run -1 bin/program-version refs/heads
}

@test 'refs/tags=error' {
  run -1 bin/program-version refs/tags
}
