# Best Practices

These are more specific to Basalt; for general reference the [Bash Hackers Wiki](https://wiki.bash-hackers.org/doku.php) and [Greg's Wiki](https://mywiki.wooledge.org)

## Names for functions / executables

With shell scripting, functions and executable files have similarities. It is important to differentiate them. Do so with the following convention

- functions: snake_case
- executable / binaries: hyphen-case

Functions are also allowed (and encouraged) to use `.` as a sort of pseudo-namespacing feature. For example:

```sh
bash_args.print.log_info() { :; }
bash_args.print.log_warn() { :; }
bash_args.print.log_error() { :; }
```

## REPLY semantics

_Only_ set REPLY at the end of the function. NEVER do `REPLY+=$something`. Use an intermediate variable and assign it at end. `REPLY=$var` or `REPLY=("${var[@]}")`

This is because calls to intermediate that expect a reply also do `REPLY=`. Since variable referencing is dynamic, this nukes the variable in an parent skopes (this is the point)

## Names for variables

When capturing flags, name them like so

```sh
local flag_verbose=
```

When naming global variables, name them like so

```sh
local global_something=
```

When "returning" from a function, name your variable `REPLY` for one return value, or `REPLY1`, `REPLY2`, etc. for more than one. Naming your variable `REPLIES` is _strongly_ discouraged

Things not to do. Do not use `REPLIES`, even if you are "returning" an array. It is too confusing (different names of different values). `REPLY` also semantically covers the array case

```sh
REPLIES=(one two there)
```

## Functions

Let's take this function as an example

```sh
#!/usr/bin/env bash

str.repeat() {
	unset REPLY; REPLY=
	local str=$1
	local -i count=$2

	local i=
	for ((i=0; i<count; ++i)); do
		REPLY+="$str"
	done; unset i
}

str.repeat "fox" 3
# => foxfoxfox
```

There are several things to note

1. `unset REPLY; REPLY=`

- We know this function will set something in `REPLY`, so we want to be sure the string starts out as empty. That way, if something unexpected happens, `REPLY` won't stay as the result of a potential previous function call.

- `unset REPLY` is required so the type of `REPLY` is reset (by default, to a string). If this isn't done, then the type of the previous result of string can potentially stay the same. For instance, if `REPLY` was previously an index array, then `REPLY=` simply makes the array empty

- Unsetting the shopt option `localvar_inherit`and and setting `localvar_unset` obviates the aforementioned code, but there may be times in which this behavior is expected, and adding the single line makes the code more copy-and-pastable portable

If there are multiple return values, there is a shortcut. Be careful, `declare -g` may have different semantics on context compared to a regular syntaxic set. Note that it is slightly more technically correct to pass `-v` to `unset`, since without it may cause an unsetting of funcations like `REPLY1() { :; }`, etc. (TODO: add `-v`, linting rule autofix?)

```sh
unset REPLY{1,2,3,4,5}
# REPLY1=; REPLY2=; REPLY3=; REPLY4=; REPLY5=
declare -g REPLY{1,2,3,4,5}
```

2. `local i=`

Ensure the variable is function scoped so it doesn't modify the value of `i` in the context of the function caller

3 `unset i`

Since the variable is function scoped and we only needed to use it in the for block, `unset` it to prevent any hard-to-track down bugs

## Errors / exit codes

It's important to understand some subtle gotchias about handling errors in Bash

Incorrect:

```sh
#!/usr/bin/env bash

curl "$@"
```

Correct:

```sh
#!/usr/bin/env bash
set -eo pipefail

if curl -fsSL "$@"; then :; else
  printf '%s\n' "Error: Curl failed (code $?)" >&2
  exit $?
fi
```

- For larger scripts, it may be important to print extra information about an error, or pass it up the stack (eg. using [bash-error](https://github.com/hyperupcall/bash-error)). Checking for an error like `if ! curl; then ...` is tempting, but the very act of using `!` will change the value of `$?`, so it is best to avoid it (assuming you want the correct value of `$?`). A good pattern is to use the no-op builtin in the `then` command list, and put the real error handling in the `else` command list

- For smaller scripts, I highly recommend `set -e`, but for larger ones, you should be checking return values anyways, so it should be less relevant - it becomes more of a tradeoff between exiting your program without notifying the user versus having potentially "undefined" behavior. The latter can be significantly mitigated if you consistently check for empty positional parameters (like I do with [Basalt](https://github.com/hyperupcall/basalt)), etc.

## Project Layout

An attempt to describe the project layout of a Basalt package. It's important to keep this consistent across repositories

TODO: write something thats actually readable

### Goals

1. Make it easier to run static code analysis on Bash projects
2. Enable features within [Basalt](https://github.com/hyperupcall/basalt) that dependent on a more standard structure and environment variables
3. Make it potentially easy to distribute on a system

```txt
.git/
.gitignore
.gitattributes
.basalt.toml
pkg/
    bin/
        NAME
    src/
        bin/
            NAME.sh
        public/
        util/
    completions/
    man/
        man1/
            NAME.1
    share/

docs/
tests/
```

For example, if the project is called `bash-http`, it will be installed to `/usr/lib/bash-http/{.basalt.toml,pkg,docs,etc.}` This way, `BASALT_PACKAGE_DIR` still works when doing things like `BASALT_PACKAGE_DIR/man`. Just like local mode, symlinks will be created for things in each place defined by `basalt.toml`

### Options

_Always_ ensure `-E` is set:

```sh

err_handler() {
  local exit_code=$?
  core.print_stacktrace
  exit $exit_code
}
core.trap_add 'err_handler' ERR

set -eE

fn3() {
	false
}

fn2() {
	fn3
}

fn2
```

Other things like `shift_verbose` will be set like default too (see hyperupcall/basalt#96)
