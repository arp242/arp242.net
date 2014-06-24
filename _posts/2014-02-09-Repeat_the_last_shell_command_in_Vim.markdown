---
layout: post
title: Repeat the last shell command in Vim
---

Vim script to repeat the last shell command you used (such as `!make`)


This Vim function searches your command history for the first command to start
with `!`, and executes that.

This is really useful when you need to either compile something, and/or want to
test whatever you’re working on.

Note that **this is potentially dangerous**. The history is saved between editor
sessions, so if in some previous session you did `rm *`, and you do `\r` the
results can be... unpleasant...  
It’s not a show-stopper for me personally, but be careful!

It only searches the last 100 commands, obviously, you could change this number
(History indexing starts at -1, which is the last command you typed, so the
lower the number, the further is searched).

I [originally wrote this on unix.stackexchange.com](http://unix.stackexchange.com/questions/113907/vim-map-last-shell-command-to-the-key/113968),
I use `!` quite a lot, yet it never occured to me to make a keybind out of this.  
Yet another example showing that asking the right *question*, is just as
important, or perhaps even more important, important than giving the right
*answer*.


	fun! LastCommand()
		" Search back this many history entries
		let l:num = -100

		let l:i = -1
		while l:i > l:num
			let l:cmd = histget("cmd", l:i)
			if strpart(l:cmd, 0, 1) == "!"
				let l:i = 1
				execute l:cmd
				break
			endif
			let l:i -= 1
		endwhile

		if l:i < 1
			echoerr "No command found"
		endif
	endfun

	nnoremap <Leader>r :call LastCommand()<CR>
