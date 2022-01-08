# Best Practices

These are more specific to Basalt; for general reference the [Bash Hackers Wiki](https://wiki.bash-hackers.org/doku.php) and [Greg's Wiki](https://mywiki.wooledge.org)

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

- `unset REPLY` is required to the type of `REPLY` is reset (by default, to a string). If this isn't done, then the type of the previous result of string can potentially stay the same. For instance, if `REPLY` was previously an index array, then `REPLY=` simply makes the array empty

- Unsetting the shopt option `localvar_inherit`and and setting `localvar_unset` obviates the aforementioned code, but there may be times in which this behavior is expected, and adding the single line makes the code more copy-and-pastable portable

If there are multiple return values, there is a shortcut. Be careful, `declare -g` may have different semantics on context compared to a regular syntaxic set. Note that it is slightly more technically correct to pass `-v` to `unset`, since without it may cause an unsetting of funcations like `REPLY1() { :; }`, etc. (TODO: add `-v`, linting rule autofix?)

```sh
unset REPLY{1,2,3,4,5}
# REPLY1=; REPLY2=; REPLY3=; REPLY4=; REPLY5=
declare -g REPLY{1,2,3,4,5}
```

2. `local i=`

Ditto for the previous reasons. Ensure the variable is function scoped

3 `unset i`

Since the variable is function scoped and we only needed to use it in the for block, `unset` it to prevent any hard-to-track down bugs

## Errors / exit codes

It's important to understand some subtle gotchias about handling errors in Bash

```sh
#!/usr/bin/env bash
set -e

if curl "$@"; then :; else
  printf '%s\n' "Error: Curl failed (code $?)" >&2
  exit $?
fi
```

- For larger scripts, it may be important to print extra information about an error, or pass it up the stack (eg. using [bash-error](https://github.com/hyperupcall/bash-error)). Checking for an error like `if ! curl; then ...` is tempting, but the very act of using `!` will change the value of `$?`, so it is best to avoid it (assuming you want the correct value of `$?`). A good pattern is to use the no-op builtin in the `then` command list, and put the real error handling in the `else` command list

- For smaller scripts, I highly recommend `set -e`, but for larger ones, you should be checking return values anyways, so it should be less relevant - it becomes more of a tradeoff between exiting your program without notifying the user versus having potentially "undefined" behavior. The latter can be significantly mitigated if you consistently check for empty positional parameters (like I do with [basalt](https://github.com/hyperupcall/basalt)), etc.
