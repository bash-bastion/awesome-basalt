# Awesome Basalt

All links packages for [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager

This list contains projects written with a shell language that are either (1) Bash or POSIX Shell applications that are globally installable or (2) _Bash libraries_ that are locally (per-project) installable

Keep in mind that everything listed should be considered at least _bleeding edge_. Notwithstanding the label, many could be considered "stable" to comprehensive test suites and minimalist functionality. I'll also add that I'm dogfooding everything listed here, and most things _just work_ on _my machine_

## General use

### Applications

- [hyperupcall/woof](https://github.com/hyperupcall/woof) - A generalized version manager (replace pyenv,nvm,n,rvm,rbenv,crenv,phpenv, etc. all at once) (FEATURED)
- [hyperupcall/shtest](https://github.com/hyperupcall/shtest) - POSIX shell test runner
- [hyperupcall/bake](https://github.com/hyperupcall/bake) - Simple Bash based Makefile alternative

### Libraries

- [hyperupcall/bash-object](https://github.com/hyperupcall/bash-object) - Manipulate heterogenous data hierarchies in Bash (FEATURED)
- [hyperupcall/bash-args](https://github.com/hyperupcall/bash-args) - A cute little Bash library for blazing fast argument parsing
- [hyperupcall/bash-toml](https://github.com/hyperupcall/bash-toml) - A kickass Toml parser written in pure Bash
- [hyperupcall/bash-semver](https://github.com/hyperupcall/bash-semver) - Semantic version library for Bash
- [hyperupcall/bats-all](https://github.com/hyperupcall/bats-all) - Aggregation of Bats utility libraries
- [hyperupcall/bash-error](https://github.com/hyperupcall/bash-error) - Ergonomic error handling in Bash
- [hyperupcall/bash-algo](https://github.com/hyperupcall/bash-algo) - Common algorithms implemented in pure Bash
- [hyperupcall/bash-str](https://github.com/hyperupcall/bash-str) - String manipulation functions for Bash
- [hyperupcall/bash-error](https://github.com/hyperupcall/bash-error) - Ergonomic error handling in Bash
- [hyperupcall/template-bash](https://github.com/hyperupcall/template-bash) - A working template of how a Basalt Bash package should work

## Personal use

Because the Basalt ecosystem is so small, I decided to include some packages that I use personally. Of course, they should work on any Linux machine, but documentation and testing is not as extensive as the other repositories listed

- [hyperupcall/glue](https://github.com/hyperupcall/glue) - Hypergeneral boilerplate manager and task runner
- [hyperupcall/choose](https://github.com/hyperupcall/choose) - System for choosing default applications, programs, and utilities
- [hyperupcall/dotshellgen](https://github.com/hyperupcall/dotshellgen) - Dotfile categorization and concatenation
- [hyperupcall/dotshellextract](https://github.com/hyperupcall/dotshellextract) - Extract annotated parts of your shell dotfiles into a separate file

## Miscellaneous

### Similar Lists

- [awesome-bash](https://github.com/awesome-lists/awesome-bash)
- [awesome-shell](https://github.com/alebcay/awesome-shell)

### Similar Package Managers

Basalt works with existing "packages", as defined by both Basher and pkg. Browse their lists as well:

- [Basher](https://www.basher.it/package)
- [bpkg](https://bpkg.sh/packages/name)
