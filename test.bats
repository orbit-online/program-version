#!/usr/bin/env bats
# shellcheck disable=2030,2031

setup_file() {
  bats_require_minimum_version 1.5.0
}

@test 'refs/heads/main=main' {
  run ./program-version.sh refs/heads/main
  [ "$output" = "main" ]
}

@test 'refs/heads/master=master' {
  run ./program-version.sh refs/heads/master
  [ "$output" = "master" ]
}

@test 'refs/heads/ft-refactor=ft-refactor' {
  run ./program-version.sh refs/heads/ft-refactor
  [ "$output" = "ft-refactor" ]
}

@test 'refs/tags/v1.0.3=v1.0.3' {
  run ./program-version.sh refs/tags/v1.0.3
  [ "$output" = "v1.0.3" ]
}

@test 'refs/tags/1.0.3=v1.0.3' {
  run ./program-version.sh refs/tags/1.0.3
  [ "$output" = "v1.0.3" ]
}

@test 'refs/tags/very-pinned=very-pinned' {
  run ./program-version.sh refs/tags/very-pinned
  [ "$output" = "very-pinned" ]
}

@test 'refs/tags/f1.0.3=f1.0.3' {
  run ./program-version.sh refs/tags/f1.0.3
  [ "$output" = "f1.0.3" ]
}

@test 'refs/tags/v=v' {
  run ./program-version.sh refs/tags/v
  [ "$output" = "v" ]
}

@test 'e02d09699ffb56440f34cb7448a0bc436e3ae212=e02d0969' {
  run ./program-version.sh e02d09699ffb56440f34cb7448a0bc436e3ae212
  [ "$output" = "e02d0969" ]
}

@test 'e02d09699ffb56440f34cb7448=error' {
  run -1 ./program-version.sh e02d09699ffb56440f34cb7448
}

@test 'master=error' {
  run -1 ./program-version.sh master
}

@test 'v1.0.3=error' {
  run -1 ./program-version.sh v1.0.3
}

@test 'refs/heads=error' {
  run -1 ./program-version.sh refs/heads
}

@test 'refs/tags=error' {
  run -1 ./program-version.sh refs/tags
}
