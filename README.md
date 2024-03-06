# program-version

CLI tool and GitHub action to determine the program version based on a git ref.  
Take a look at [image-version](https://github.com/orbit-online/image-version) if
you need the container image tag variant.

## Behavior

| git ref                                                        | program version |
| -------------------------------------------------------------- | --------------- |
| `refs/heads/main`                                              | `main`          |
| `refs/heads/master`                                            | `master`        |
| `refs/heads/ft-refactor`                                       | `ft-refactor`   |
| `refs/tags/v1.0.3`                                             | `v1.0.3`        |
| `refs/tags/1.0.3`                                              | `v1.0.3`        |
| `refs/tags/very-pinned` (treated just like branches)           | `very-pinned`   |
| `refs/tags/f1.0.3` (treated just like branches)                | `f1.0.3`        |
| `refs/tags/v`                                                  | `v`             |
| `e02d09699ffb56440f34cb7448a0bc436e3ae212` (i.e. non-symbolic) | `e02d0969`      |
| `e02d09699ffb56440f34cb7448` (not 40 hex chars)                | error           |
| `master` (no `refs/heads/` prefix)                             | error           |
| `v1.0.3` (no `refs/tags/` prefix)                              | error           |
| `refs/heads/` (empty branch name)                              | error           |
| `refs/tags/` (empty tag name)                                  | error           |

## CLI

### Installation

With [μpkg](https://github.com/orbit-online/upkg)

```
upkg install -g orbit-online/program-version@<VERSION>
```

### Usage

```
program-version REF
```

When using μpkg you can retrieve the installed version of your package and
pass that straight to this tool (`git symbolic-ref` is used as a fallback
in order for it to work in your git repo while developing):

```
PKGROOT=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
version=$(program-version "$(jq -re '.version // empty' "$PKGROOT/upkg.json" 2>/dev/null || git -C "$PKGROOT" symbolic-ref HEAD)")
```

## GitHub action

### Parameters

- `ref`: The git ref to calculate the version from, defaults to
  `${{ github.ref }}`.

### Usage

```
name: Release

on:
  push:
    branches: [ '*' ]
    tags: [ 'v*' ]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
    - id: program_version
      uses: orbit-online/program-version@v0.9.0
    - uses: actions/checkout@v4
    - uses: docker/setup-buildx-action@v2
    - uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_HUB_USERNAME }}
        password: ${{ secrets.DOCKER_HUB_TOKEN_RW }}
    - name: Build & push
      uses: docker/build-push-action@v4
      with:
        file: Dockerfile
        tags: orbit-online/my-prog:latest
        push: true
        build-args: |
          "VERSION=${{ steps.program_version.outputs.version }}"
```
