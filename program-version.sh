#!/usr/bin/env bash

main() {
  set -eo pipefail; shopt -s inherit_errexit

  local ref=${1:?'Usage: image-version REF'}
  if [[ $ref =~ refs/tags/v?[0-9]+ ]]; then
    local tag=${ref#'refs/tags/'}
    printf "v%s\n" "${tag#v}"
  elif [[ $ref = refs/tags/* ]]; then
    printf "%s\n" "${ref#'refs/tags/'}"
  elif [[ $ref = refs/heads/?* ]]; then
    printf "%s\n" "${ref#'refs/heads/'}"
  elif [[ $ref =~ ^[0-9a-f]{40}$ ]]; then
    printf "%s\n" "${ref:0:8}"
  else
    printf "program-version.sh: REF must start with refs/tags/, refs/heads/, or be a shasum. Got '%s'.\n" "$ref" >&2
    return 1
  fi
}

main "$@"
