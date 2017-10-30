---
layout: code
title: "goimport"
link: "goimport"
last_version: "master"
---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)
[![GoDoc](https://godoc.org/arp242.net/goimport?status.svg)](https://godoc.org/arp242.net/goimport)
[![Go Report Card](https://goreportcard.com/badge/github.com/Carpetsmoker/goimport)](https://goreportcard.com/report/github.com/Carpetsmoker/goimport)
[![Build Status](https://travis-ci.org/Carpetsmoker/goimport.svg?branch=master)](https://travis-ci.org/Carpetsmoker/goimport)
[![codecov](https://codecov.io/gh/Carpetsmoker/goimport/branch/master/graph/badge.svg)](https://codecov.io/gh/Carpetsmoker/goimport)

`goimport` is a tool to add, remove, or replace imports in Go files.

Example usage:

	# Add errors package.
	$ goimport -add errors foo.go

	# Remove errors package.
	$ goimport -rm errors foo.go

	# Add errors package aliased as "errs"
	$ goimport -add errors:errs foo.go

TODO:

- Make `-rm` deal with named imports.
- What to do if a package is already imported?
- Error out if package not in GOPATH.
- Remove quotes in e.g. `-add '"errors"'
- Make sure it works with trailing slash, e.g. `-add the/path/with/slash/`
- Add automatic `go get`?
- Add `-toggle` to toggle importing/removing
- Possible to print out only import block?
