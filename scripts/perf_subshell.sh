#!/usr/bin/env bash

fast_basename_work() {
	local path="$1"
	path=${path%/}
	printf '%s\n' "{path##*/}"
}

slow_basename() {
	unset -v REPLY
	REPLY=$(basename "$1")
}

fast_basename() {
	unset -v REPLY
	REPLY=$(fast_basename_work "$1")
}

faster_basename() {
	unset -v REPLY; REPLY=
	local path="$1"
	path=${path%/}
	path=${path##*/}
	REPLY=$path
}

main() {
	"$1" "$PWD"
	local _result="$REPLY"
}

main "$@"
