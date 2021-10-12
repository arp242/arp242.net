---
title: "Some zshrc tricks"
date: 2020-05-22
tags: ['Unix', 'zsh']
filetype: zsh
hatnote: |
    Discussions:
      [Lobsters](https://lobste.rs/s/tgmzke/some_zshrc_tricks),
      [/r/commandline](https://www.reddit.com/r/commandline/comments/gofuh1/some_zshrc_tricks/)
---

Some useful "tricks" from my `~/.zshrc`; [full version here][zshrc]. Not all of
this is "copy/paste ready" but it should give you some inspiration to build
your own stuff :-)

General tip: I found the [User's Guide to ZSH][guide] very helpful when learning
about zsh. It hasn't been updated in a while and isn't even finished, but found
it's quite well-written and useful. Go read it!

[zshrc]: https://github.com/arp242/dotfiles/blob/master/zsh/zshrc
[guide]: http://zsh.sourceforge.net/Guide/

Directory shortcuts
-------------------

Define directory shortcuts with `hash -d` so you can use `cd ~x` and `vim
~x/file` instead of `cd /very/long/and/often/accessed/path`. Some examples:

    # Directory shortcuts
    hash -d pack=$HOME/.cache/vim/pack/plugins/start
    hash -d vim=/usr/share/vim/vim82
    hash -d d=$HOME/code/arp242.net/_drafts
    hash -d p=$HOME/code/arp242.net/_posts
    hash -d go=/usr/lib/go/src
    hash -d c=$HOME/code
    hash -d gc=$HOME/code/goatcounter

So if I have an idea for a new post here I just type `vi ~d/$(td)-idea.markdown`
and presto (td is `alias td='echo $(date +%Y-%m-%d)'`).

If you put `%~` in your `PROMPT` then the short version will show up there, too:

{:class="ft-cli"}
    $ PROMPT='[%~]$ '
    [~]$ cd ~/.cache/vim/pack/plugins/start
    [~/.cache/vim/pack/plugins/start]$ hash -d pack=$HOME/.cache/vim/pack/plugins/start
    [~pack]$

A related little helper I have is `hashcwd`, to quickly add the current
directory in case you find yourself in a (very) long path taking up all your
screen space or want to make a temporary "bookmark":

    hashcwd() { hash -d "$1"="$PWD" }

And then:

{:class="ft-cli"}
    [~/go/pkg/mod/golang.org/x/tools@v0.0.0-20200519205726-57a9e4404bf7/go/analysis]$ hashcwd a
    [~a]$ 

Filter history completion with what you typed
---------------------------------------------

Make up and down arrow take what's typed on the commandline in to account. E.g.
if you type `ls` and press up it will only find history entries that start with
`ls`:

    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search

    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search

    bindkey '^[[A'  up-line-or-beginning-search    # Arrow up
    bindkey '^[OA'  up-line-or-beginning-search
    bindkey '^[[B'  down-line-or-beginning-search  # Arrow down
    bindkey '^[OB'  down-line-or-beginning-search

I use this a lot, and is the #1 thing I miss if it's not available.

You can also use `history-incremental-search-backward` to search the entire
commandline, but I never cared for it much as `ls` will match a**ls**amixer,
too**ls**, t**ls**, tota**ls**, docker **ls**, and probably more.

Easier PATH
-----------

Many systems link `/bin` to `/usr/bin` and storing all of those in PATH isn't
too useful. Some helper functions to prepend or append to `PATH` which also
check if the path exists so it's easier to write a portable zshrc:

    typeset -U path  # No duplicates
    path=()

    _prepath() {
        for dir in "$@"; do
            dir=${dir:A}
            [[ ! -d "$dir" ]] && return
            path=("$dir" $path[@])
        done
    }
    _postpath() {
        for dir in "$@"; do
            dir=${dir:A}
            [[ ! -d "$dir" ]] && return
            path=($path[@] "$dir")
        done
    }

    _prepath /bin /sbin /usr/bin /usr/sbin /usr/games
    _prepath /usr/pkg/bin   /usr/pkg/sbin   # NetBSD
    _prepath /usr/X11R6/bin /usr/X11R6/sbin # OpenBSD
    _prepath /usr/local/bin /usr/local/sbin

    _prepath "$HOME/go/bin"                # Go
    _prepath "$HOME/.local/bin"            # My local stuff.
    if [[ -d "$HOME/.gem/ruby" ]]; then    # Ruby
        for d in "$HOME/.gem/ruby/"*; do
            _postpath "$d/bin";
        done
    fi

    unfunction _prepath
    unfunction _postpath

Easier alias
------------

A little `_exist` helper to check if a binary exists is similarly useful for a
portable zshrc:

    _exists() { (( $+commands[$1] )) }

    _exists vim      && export EDITOR=vim
    _exists less     && export PAGER=less
    _exists bsdtar   && alias tar='bsdtar'
    _exists htop     && alias top='htop'

    if _exists vim; then
        alias vim="vim -p"
        alias vi="vim"
    fi

    unfunction _exists

Edit ag and grep results
------------------------

"ag edit" and "grep edit" to quickly open stuff found with `ag` or `grep` in
Vim:

    # "ag edit" and "grep edit".
    age() {
        vim \
            +'/\v'"${1/\//\\/}" \
            +':silent tabdo :1 | normal! n' \
            +':tabfirst' \
            -p $(ag "$@" | cut -d: -f1 | sort -u)
    }
    grepe() {
        vim \
            +'/\v'"${1/\//\\/}" \
            +':silent tabdo :1 | normal! n' \
            +':tabfirst' \
            -p $(grep "$@" | cut -d: -f1 | sort -u)
    }

    $ ag pattern
    [.. check if results look right ..]

    $ age pattern
    [open in Vim]

This will also search for the pattern with `/pattern` in Vim and move to the
first match for every tab (yes, I use Vim tabs, in spite of Vim-purist
philosophy that they're bad).

Caveat: the Vim regexp syntax isn't quite the same as extended POSIX or PCRE, so
the pattern doesn't always work as expect in Vim. It works most of the time
though.

Caveat 2: sometimes I use this to check if I have the expected results:

{:class="ft-cli"}
    $ ag pattern | less

And then I modify it `age` while forgetting to remove the `less`:

{:class="ft-cli"}
    $ age pattern | less

Vim will not like this 😅 Not sure if we can write something to be a bit smarter
about this. Ideally *I* would be smarter, but alas I am not.

Global aliases
--------------

You can define global aliases with `alias -g`, which will work everywhere. I use
it to make piping stdout and stderr to less or Vim a bit easier:

    alias -g VV=' |& vim -'
    alias -g LL=' |& less'

{:class="ft-cli"}
    $ ls LL
    $ go test -v VV

*Bonus Vim tip*: convert a buffer to "scratch" with:

{:class="ft-vim"}
    " Convert buffer to and from scratch.
    command S
        \  if &buftype is# 'nofile' | setl swapfile buftype= bufhidden=
        \| else                     | setl noswapfile buftype=nofile bufhidden=hide | endif
        \| echo printf('swapfile=%s buftype=%s bufhidden=%s', &swapfile, &buftype, &bufhidden)

And then use:

    alias -g VV=' |& vim +S -'

Use `:S` from Vim to make it a regular buffer again.

Playground environment
----------------------

Set up a quick "tmp go" environment for testing; I mostly use Go these days, but
this can be done for other languages as well:

    tgo() {
        tmp="$(mktemp -p /tmp -d "tgo_$(date +%Y%m%d)_XXXXXXXX")"
        printf 'package main\n\nfunc main() {\n\n}\n' > "$tmp/main.go"
        printf 'package main\n\nfunc TestMain(t *testing.T) {\n\n}\n\n' > "$tmp/main_test.go"
        printf 'func BenchmarkMain(b *testing.B) {\n\tb.ReportAllocs()\n\tfor n := 0; n < b.N; n++ {\n\t}\n}\n' >> "$tmp/main_test.go"

        printf 'module %s\n' "$(basename "$tmp")" > "$tmp/go.mod"
        (
            cd "$tmp"
            vim -p main.go main_test.go
            echo "$tmp"
        )
    }

It will create a `main.go` and `main_test.go` in `/tmp/` with some useful
boilerplate and a `go.mod` so it's recognized as a module (required to get
`gopls` etc. to work well) and opens the whole shebang in Vim.

This *won't* be removed after Vim exits on purpose, so you won't lose your
prototype.

Run stored SQL queries
----------------------

I have a bunch of scripts in `~/docs/sql/scripts` to get some stats and whatnot
from PostgreSQL. This adds a `sql` command with tab-completion
to that directory and runs `psql` with some useful flags:

    sql() {
        cmd="psql -X -P linestyle=unicode -P null=NULL goatcounter"
        f="$HOME/docs/sql/scripts/$1"
        if [[ -f "$f" ]]; then
            eval "$cmd" < "$HOME/docs/sql/scripts/$1" | less -S
        else
            eval "$cmd" <<< "$1" | less -S
        fi
    }
    _sql() { _files -W ~/docs/sql/scripts }
    compdef _sql sql

If the file doesn't exist then the query is just run:

{:class="ft-cli"}
    $ sql ls-inactive.sql

    $ sql 'select * from sites'

`less -S` prevents wrapping long lines, which I find more useful for tabular
output.

An expanded version of the above which accepts a database name and allows
organising scripts by database [can be found here][sql.zsh].

[sql.zsh]: https://gitlab.com/dmfay/dotfiles/-/blob/master/zsh/sql.zsh

Shortcuts to edit commandline
-----------------------------

Custom mappings to preform some common substitutions, use `<C-r>` to prepend
`doas` to the commandline, or `<C-r>` to replace the first word with `rm`:

    insert_doas() { zle beginning-of-line; zle -U "doas " }
    replace_rm()  { zle beginning-of-line; zle delete-word; zle -U "rm " }

    zle -N insert-doas insert_doas
    zle -N replace-rm replace_rm

    bindkey '^s'    insert-doas
    bindkey '^r'    replace-rm
