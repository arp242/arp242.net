#!/usr/bin/env python3

import sys, re

# First introductionary line; don't need this, and neither do we need the last modeline.
vimdoc = ''.join(open(sys.argv[1]).readlines()[1:-1])

# Header
# ==============================================================================
# OPTIONS                                                *undofile-warn-options*
def repl(m):
	title = m.groups()[0].capitalize()
	return title + '\n' + ('=' * len(title))
vimdoc = re.sub(r'={40,90}\n(\w+)( *\*.*?\*)?\n', repl, vimdoc)

# Links to tags
# TODO: Make weblink if possible:
#  [`:help undofile-warn-options`](http://vimhelp.appspot.com/undofile_warn.txt.html#undofile%2dwarn%2doptions)
vimdoc = re.sub(r'\|(.*?)\|', r'`\1`', vimdoc)

# Tag definition
# *g:undofile_warn_prevent*
vimdoc = re.sub(r'\*(.*?)\*', r'`\1`', vimdoc)

# Replace much the the indentation that we don't need
vimdoc = re.sub(r'\n +', r'\n', vimdoc)

# Code blocks, also add indentation again
def repl(m):
	g = '\n'.join([ '    ' + l for l in m.groups()[0].split('\n') ])
	return '\n\n' + g + '\n\n'
vimdoc = re.sub(r'\n+>\n(.*)\n<\n+', repl, vimdoc, 0, re.DOTALL)

print(vimdoc.strip())
