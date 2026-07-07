# program-version

CLI tool and GitHub action to determine the program version based on a git ref.  
Take a look at [image-version](https://github.com/orbit-online/image-version) if
you need the container image tag variant.

## Behavior

| git ref                                                        | program version      | prefix     |
| -------------------------------------------------------------- | -------------------- | ---------- |
| `refs/heads/main`                                              | `main`               | `v`        |
| `refs/heads/master`                                            | `master`             | `v`        |
| `refs/heads/ft-refactor`                                       | `ft-refactor`        | `v`        |
| `refs/tags/v1.0.3`                                             | `v1.0.3`             | `v`        |
| `refs/tags/v1.0.3`                                             | `v1.0.3`             | `v`        |
| `refs/tags/1.0.3`                                              | `1.0.3`              | `v`        |
| `refs/tags/very-pinned` (prefix must be followed by a number)  | `very-pinned`        | `v`        |
| `refs/tags/v`                                                  | `v`                  | `v`        |
| `refs/tags/f1.0.3` (treated just like branches)                | `f1.0.3`             | `v`        |
| `e02d09699ffb56440f34cb7448a0bc436e3ae212` (i.e. non-symbolic) | `e02d0969`           | `v`        |
| `e02d09699ffb56440f34cb7448` (not 40 hex chars)                | error                | `v`        |
| `master` (no `refs/heads/` prefix)                             | error                | `v`        |
| `v1.0.3` (no `refs/tags/` prefix)                              | error                | `v`        |
| `refs/heads/` (empty branch name)                              | error                | `v`        |
| `refs/tags/` (empty tag name)                                  | error                | `v`        |
| **Custom prefix**                                              |                      |            |
| `refs/heads/main`                                              | `main`               | `mytool-v` |
| `refs/heads/mytool-vmain`                                      | `mytool-vmain`       | `mytool-v` |
| `refs/tags/v1.0.3`                                             | `v1.0.3`             | `mytool-v` |
| `refs/tags/mytool-v1.0.3`                                      | `v1.0.3`             | `mytool-v` |
| `refs/tags/mytool-v1`                                          | `v1`                 | `mytool-v` |
| `refs/tags/mytool-v1.0.3` (prefix=`v`)                         | `mytool-v1.0.3`      | `v`        |
| `refs/tags/1.0.3`                                              | `1.0.3`              | `mytool-v` |
| `refs/tags/mytool-very-pinned`                                 | `mytool-very-pinned` | `mytool-v` |
| `refs/tags/mytool-v3ry-pinned`                                 | `v3ry-pinned`        | `mytool-v` |
| `refs/tags/mytool-v`                                           | `mytool-v`           | `mytool-v` |

## CLI

## Installation

See [the latest release](https://github.com/orbit-online/program-version/releases/latest) for instructions.

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

### Inputs

| Name     | Description                                | Default             |
| -------- | ------------------------------------------ | ------------------- |
| `ref`    | The git ref to calculate the version from. | `${{ github.ref }}` |
| `prefix` | Prefix to replace with 'v' in tags.        | `v`                 |

### Outputs

| Name      | Description          |
| --------- | -------------------- |
| `version` | The program version. |

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
      uses: orbit-online/program-version@v1
    - uses: actions/checkout@v7
    - uses: docker/setup-buildx-action@v2
    - uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_HUB_USERNAME }}
        password: ${{ secrets.DOCKER_HUB_TOKEN_RW }}
    - name: Build & push
      uses: docker/build-push-action@v5
      with:
        file: Dockerfile
        tags: orbit-online/my-prog:latest
        push: true
        build-args: |
          "VERSION=${{ steps.program_version.outputs.version }}"
```
