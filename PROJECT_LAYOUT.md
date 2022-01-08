# Project Layout

An attempt to describe the project layout of a Basalt package. It's important to keep this consistent across repositories

TODO: write something thats actually readable

## Goals

1. Make it easier to run static code analysis on Bash projects
2. Enable features within [Basalt](https://github.com/hyperupcall/basalt) that dependent on a more standard structure and environment variables
3. Make it potentially easy to distribute on a system

```txt
.git/
.gitignore
.gitattributes
.basalt.toml
pkg/
    src/
        bin/
            NAME
        cmd/
            NAME.sh
        public/
        util/
    completions/
    man/
    share/
          man/
              NAME.1
docs/
tests/
```

For example, if the project is called `bash-http`, it will be installed to `/usr/lib/bash-http/{.basalt.toml,pkg,docs,etc.}` This way, `BASALT_PACKAGE_DIR` still works when doing things like `BASALT_PACKAGE_DIR/man`. Just like local mode, symlinks will be created for things in each place defined by `basalt.toml`
