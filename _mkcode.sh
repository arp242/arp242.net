#!/bin/sh

root="$(dirname "$(readlink -f "$0")")"
export GOPATH="$root"
go run "$root/mkcode.go" "$root" "$@"
