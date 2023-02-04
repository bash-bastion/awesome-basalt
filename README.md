# Awesome Basalt

All links are packages for [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager.

This list contains projects written with a shell language that are either (1) Bash or POSIX Shell applications that are globally installable or (2) _Bash libraries_ that are locally (per-project) installable.

Keep in mind that everything listed should be considered at least _bleeding edge_. Notwithstanding the label, many could be considered "stable" to comprehensive test suites and minimalist functionality. I'll also add that I'm dogfooding everything listed here, and most things _just work_ on _my machine_.

There is also a [best practices](./BEST_PRACTICES.md) file, which contains some reminders for how to write defensive Bash (which is a _must_ when writing Basalt packages).

## General use

### Applications

- [hyperupcall/bake](https://github.com/hyperupcall/bake) - A Bash-based Make alternative (FEATURED)
- [hyperupcall/woof](https://github.com/hyperupcall/woof) - The version manager to end all version managers
- [hyperupcall/hookah](https://github.com/hyperupcall/hookah) - An elegantly minimal solution for Git hooks
- [hyperupcall/bash_config](https://github.com/hyperupcall/bash_config) - [`fish_config`](https://fishshell.com/docs/current/cmds/fish_config.html) for Bash
- [hyperupcall/shelltest](https://github.com/hyperupcall/shelltest) - A test runner for POSIX-compliant shells
- [hyperupcall/neodkms](https://github.com/hyperupcall/neodkms) - An improved DKMS

### Libraries

- [hyperupcall/bash-object](https://github.com/hyperupcall/bash-object) - Manipulate heterogenous data hierarchies in Bash (FEATURED)
- [hyperupcall/bash-utility](https://github.com/hyperupcall/bash-utility) - A standard utility library for Bash (previously `bash-std`)
- [hyperupcall/bash-args](https://github.com/hyperupcall/bash-args) - A cute little Bash library for blazing fast argument parsing
- [hyperupcall/bash-term](https://github.com/hyperupcall/bash-term) - Bash library for terminal escape sequences
- [hyperupcall/bash-toml](https://github.com/hyperupcall/bash-toml) - A kickass Toml parser written in pure Bash
- [hyperupcall/bash-json](https://github.com/hyperupcall/bash-json) - A Parse JSON in Bash
- [hyperupcall/bats-all](https://github.com/hyperupcall/bats-all) - Aggregation of the three most popular Bats utility libraries
- [hyperupcall/bash-core](https://github.com/hyperupcall/bash-core) - Core functions for any Bash program
- [hyperupcall/bash-algo](https://github.com/hyperupcall/bash-algo) - Common algorithms implemented in pure Bash
- [hyperupcall/bash-http](https://github.com/hyperupcall/bash-http) - Bash web servers for everyone! (not released)
- [hyperupcall/bash-tui](https://github.com/hyperupcall/bash-tui) - Bash library for making TUI's (not released)

## Miscellaneous

### Similar Lists

- [awesome-bash](https://github.com/awesome-lists/awesome-bash)
- [awesome-shell](https://github.com/alebcay/awesome-shell)

### Similar Package Managers

Basalt works with existing "packages", as defined by both Basher and pkg. Browse their lists as well:

- [Basher](https://www.basher.it/package)
- [bpkg](https://bpkg.sh/packages/name)
