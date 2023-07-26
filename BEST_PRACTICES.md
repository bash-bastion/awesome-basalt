# Best Practices

These Best Practices are more specific to Basalt; for general reference, see the the [Bash Hackers Wiki](https://wiki.bash-hackers.org/doku.php) and [Greg's Wiki](https://mywiki.wooledge.org).

Things not mentioned here are already handled by [Basalt](https://github.com/hyperupcall/basalt) (ex. `set -ET`).

## Names for executables and functions

Executables should match the regex `[[:alpha:]][[:alnum:]-]*`.

Functions should match the regex `[[:alpha:]][[:alnum:]_:.]*`.

Use `::` or `.` to namespace your functions. `.` is _highly_ preferred. For example:

```sh
bash_core.log_info() { :; }
bash_core.log_warn() { :; }
bash_core.log_error() { :; }
```

## Names for variables

Different variable types have special naming rules, per convention.

When naming variables after command-line flags, prefix with `flag_`:

```sh
local flag_verbose=
```

When naming global variables, prefix with `g_`:

```sh
declare -g g_something=
```

When naming dynamic variables, prefix with `d_`:

```sh
local d_something=
```

When naming indirect variables, pre with `_` (`__` for libraries) or postfix with `_name`:

```sh
local -n _final_value=
local -n key_name=
```

## Private functions

When developing Bash libraries, it may be helpful to denote functions as private for internal use anyways. Do so by prefixing an underscore:

```sh
bash_core._trim_whitespace() {
	:
}
```

## Utility and helper functions

If there are many utility or helper functions, it may be helpful to name the functions after the file it's contained in. For example, a file called `util-db.sh` may contain the following functions:

- `util.db_read()`
- `util.db_write()`

And so on...

## Exiting

When exiting, _always_ supply a number:

```sh
if [ -n "$foo" ]; then
	:
else
	exit 0
fi
```

## Bashisms

Try keep Bashisms to a minimum. This keeps the code portable, in the sense that's it's easy to port to a POSIX shell. If you're not familiar with what Bashisms were introduced in what versions of Bash, it also makes your shell scripts more compatible.

For example:

```sh
# Use `fn() { ...` instead of `function() { ...` or
# `function fn { ...`
fn() {
	# OK; although `case` is slightly better, the
	# convenience likely justifies it
	if [[ $a == *glob* ]]; then
		:
	# Use single-equals and single-brackets
	elif [ "$a" = "b" ]; then
		:
	fi
}
```

Linters like ShellCheck won't print warnings on these if your shell is set to Bash. Unfortunately, more sophisticated linters aren't available yet; until then, you can use regular expressions like I do in [`checkstyle.py`](https://github.com/asdf-vm/asdf/blob/master/scripts/checkstyle.py) for the [asdf](https://github.com/asdf-vm/asdf) project.

## REPLY-Pattern

Bash only allows "returning" from a function with a numerical exit code. To work around this, use this pattern, inspired by the `read` and `select` builtins.

### Example

Simply assign the value you wish to return to `REPLY`, then return from the function:

```sh
my_basename() {
	unset -v REPLY; REPLY=
	local filepath=$1

	local result={filepath%/}
	result=${result##*/}

	REPLY=$result
}

my_basename "$0"
printf '%s\n' "The basename of '$0' is '$REPLY'"
```

There are several things to note:

- **`unset -v REPLY; REPLY=`**: Since the function is known to "return something", initialize `REPLY` to an empty string to be sure sure its value is well-known. It's not strictly necessary if every code path is guaranteed to set `REPLY` (accounting for `errexit`, traps, etc.) but it makes the code much easier to read, especially if the REPLY-pattern is frequently used.

- **`unset -v REPLY`** guarantees the type of `REPLY` is reset (by default, to a string). If this isn't done, then the type of the previous result of string can potentially stay the same. For instance, if `REPLY` was previously an index array, then `REPLY=` simply makes the array empty.

  - Unsetting the shopt option `localvar_inherit`and and setting `localvar_unset` obviates the aforementioned code, but there may be times in which this behavior is expected, and adding the single line makes the code more portable.

- **`REPLY=`** guarantees that the variable is set, to prevent any mishaps on `nounset`.

- If there are multiple return values, you may use the shortcut: `unset -v REPLY{1,2,3,4}`

- Do **NOT** use the name `REPLIES` if returning an index array - stick with `REPLY` for all variables types. It's confusing.

- Do **NOT** do `REPLY+=$something`. Use an intermediate variable and assign it at end. `REPLY=$var` or `REPLY=("${arr[@]}")`

- If you need a different name (due to Bash dynamic scope, etc.) then naming it `REPLY_OUTER` or `REPLY_INNER_*`, or `REPLY_{name}` is O.K.

- Try to only set REPLY at the beginning or end of the function

### Other benefits

This pattern makes it simple and straightforward to return multiple variables from an array. It also makes it possible to return index arrays and associative arrays.

Lastly, it also performs better. See [perf_subshell.sh](./perf_subshell.sh) for more details.

<details>

<summary>👇 Performance Results</summary>

```sh
$ for fn in slow_basename fast_basename faster_basename; do hyperfine -N --warmup 1000 --runs 1000 "./scripts/perf_subshell.sh $fn"; done
Benchmark 1: ./script.sh slow_basename
  Time (mean ± σ):       3.6 ms ±   0.2 ms    [User: 2.0 ms, System: 1.4 ms]
  Range (min … max):     3.4 ms …   8.8 ms    1000 runs

  Warning: Statistical outliers were detected. Consider re-running this benchmark on a quiet PC without any interferences from other programs. It might help to use the '--warmup' or '--prepare' options.

Benchmark 1: ./script.sh fast_basename
  Time (mean ± σ):       3.2 ms ±   0.4 ms    [User: 1.6 ms, System: 1.4 ms]
  Range (min … max):     2.9 ms …  15.1 ms    1000 runs

  Warning: Statistical outliers were detected. Consider re-running this benchmark on a quiet PC without any interferences from other programs. It might help to use the '--warmup' or '--prepare' options.

Benchmark 1: ./script.sh faster_basename
  Time (mean ± σ):       2.7 ms ±   0.3 ms    [User: 1.3 ms, System: 1.2 ms]
  Range (min … max):     2.5 ms …   8.9 ms    1000 runs

  Warning: Statistical outliers were detected. Consider re-running this benchmark on a quiet PC without any interferences from other programs. It might help to use the '--warmup' or '--prepare' options.
```

</details>

Considering real performance, I have heard that x10 performance improvement is not uncommon.

## Loops

You may wish to harden your loop code. Take the following example:

```sh
#!/usr/bin/env bash

str.repeat() {
	unset REPLY; REPLY=
	local str=$1
	local -i count=$2

	local i=
	for ((i=0; i<count; ++i)); do
		REPLY+="$str"
	done; unset -v i
}

str.repeat 'fox' 3
# => foxfoxfox
```

- **`local i=`**: Ensure the variable is function scoped instead of globally scoped.

- **`unset -v i`**: Prevent Bash's default dynamic scoping from making this variable accessible in later contexts.

Admittedly, this hardening is a bit extraneous, so I do not strongly recommend it.

## Error handling

## Stacktrace

Printing a stacktrace on `ERR` helps debugging Bash scripts tremendously. It's never been easier to do this with [`bash-core`](https://github.com/hyperupcall/bash-core):

```sh
#!/usr/bin/env bash

# This script loads Bash dependencies (including bash-core). See
# Basalt for more information: https://github.com/hyperupcall/basalt
eval "$(basalt-package-init)"
basalt.package-init || exit
basalt.package-load

# The meat
err_handler() {
  core.print_stacktrace
}
core.trap_add 'err_handler' ERR

fn() {
	# Do something naughty
	false
}
fn
```

```txt
$ ./script.sh
Stacktrace:
  in core.print_stacktrace (/home/edwin/.local/share/basalt/store/packages/github.com/hyperupcall/bash-core@v0.12.0/pkg/src/public/bash-core.sh:0)
  in err_handler (/home/edwin/groups/Bash/woof/.hidden/blah.sh:11)
  in core.private.util.trap_handler_common (/home/edwin/.local/share/basalt/store/packages/github.com/hyperupcall/bash-core@v0.12.0/pkg/src/util/util.sh:31)
  in core.private.trap_handler_ERR (/home/edwin/.local/share/basalt/store/packages/github.com/hyperupcall/bash-core@v0.12.0/pkg/src/public/bash-core.sh:42)
  in fn (/home/edwin/groups/Bash/woof/.hidden/blah.sh:17)
```

### Exit codes

If you wish to print a nice error message on failures, it is not straight-forward. Use the following guidelines. I assume that you have `errexit` enabled and have setup stacktrace printing (as I mentioned above).

❌ Incorrect

This prints an ugly stacktrace to the end-user.

```sh
work() {
	curl "$@"
}
```

❌ Incorrect

This prints to standard _output_, `!` clobbers the exit code, and executing doesn't stop.

```sh
work() {
	if ! curl "$@"; then
		printf '%s\n' "Error: Failed to download URL: ${!#} (code $?)"
	fi
}
```

✅ Correct:

```sh
work() {
	curl "$@" || {
		local code=$?
		printf '%s\n' "Error: Failed to download URL: ${!#} (code $?)" >&2
		exit $code
	}
}
```

✅ Correct:

```sh
work() {
	if curl "$@"; then :; else
		local code=$?
		printf '%s\n' "Error: Failed to download URL: ${!#} (code $?)" >&2
		exit $code
	fi
}

```

## Project Layout

The layout of Basalt projects should be consistent. My personal layout was informed with the following goals:

1. Make it easier to run static code analysis on Bash projects
2. Make it relatively straight-forward to distribute on other system (via Basalt or system package manager)

```txt
.git/
.gitignore
.gitattributes
basalt.toml
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
