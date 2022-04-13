# Interface Guidelines

Guidelines on how different Bash functions should interface with one another (and the user)

TODO: Things are not explained well here, especially the contrived examples

## Error printing

When printing errors, it is good to distinguish between _two_ types

1. Expected (internal and external) errors. Also unexpected external errors. Prefix with `Error`, `ERROR`, etc.

```sh
#!/usr/bin/env bash

print.error() {
  printf "%s\n" "Error: $1" >&2
}

curl "$@" || print.error "Request failed (code $?)"
```

2. Unexpected (internal) errors. (Essentially mismatches of internal interfaces) Prefix with `Fatal`, `FATAL`, etc.

Here, the programmer forgets to validate the input (if its nonzero). Because of this the program exits with a fatal error. Guards like these and other defensive Bash programing techniques are essentially required for large Bash codebases (if you want to stay sane)

```sh
#!/usr/bin/env bash

print.fatal() {
  printf "%s\n" "Fatal: $1" >&2
  exit 1
}

ensure.cd() {
  local dir=$1

  if [ -z "$dir" ]; then
    print.fatal "Function 'ensure.cd' expected a nonzero directory"
  fi

  if cd "$dir"; then :; else
    print.error "Command 'cd' failed. Does the directory exist?"
    exit 1
  fi
}


printf '%s' "Print directory to cd to: "
reply -r
ensure.cd "$REPLY"
```

Of course, the `[ -z ...` and `print.fatal` can get quite repetitive, so it's recommended to use some [library function](https://github.com/hyperupcall/basalt/blob/a7a86d8ad35a328d1cfd733eddb275bd83aec2ed/pkg/lib/util/ensure.sh#L26) like:

```sh
ensure.nonzero 'dir'
```
