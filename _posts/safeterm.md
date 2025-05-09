---
title: 'Safe terminal escape codes'
date: '2024-05-22'
tags: ['Unix']
---

<style>
th                         { text-align:left; }
tbody >tr >td:nth-child(1),
tbody >tr >td:nth-child(2) { font-family:monospace; white-space:pre; }
</style>

A long time ago when the Unix greybeards were slightly less grey beards everyone
was using hardware terminals to talk to some mainframe. Those terminals had
wildly different feature sets and ways to implement them, which you needed to
know about if you wanted your program to run on more than one type of terminal.
Hence systems like terminfo and termcap.

The TeleVideo 955 used `\x1b[=5l` for bold text, and the IBM 3161 used `\x1b4H`.
Both were introduced in 1985. The TeleVideo 950 from 1980 didn't support bold
text at all.

Today everyone is using software terminal emulators, and they all just implement
ANSI escape codes for the common stuff. No one is sending `\x1b[=5l` or
`\x1b4H`.

Do you still need terminfo? It depends. If you just want to style some text and
maybe do some basic cursor operations: probably not. If you want to use more
advanced operations or read key input: probably yes. If you want maximum
compatibility (there's probably someone using a hardware Wyse terminal, or SunOS
4 with CDE): absolutely.

Here is a list of terminal escape sequences that should always work on any
vaguely modern terminal, where "modern" means "since the mid-90s or so".

This was generated by looking at every terminfo file I could find with my
[termfo] tool (specifically, `termfo find-cap`) and occasionally testing some
things to verify it works. I don't care what some spec says; I care about what
works.

The escape character is always omitted; so `[0m` is `\x1b[0m`.

[termfo]: https://github.com/arp242/termfo

Graphics
--------
These can be combined in a single sequence by joining with a `;`. For example
`\x1b[1;4m` for underlined bold text. These can also be combined with colours;
for example `\x1b[1;38;2;0;255;0;41m` to set bold, foreground colour with true
colour, and background colour with 16 colour.

Just using `\x1b[1m\x1b[4m` also works.

| Code | Terminfo (short, long)      | Description                          |
| ---- | ----------------------      | -----------                          |
| [0m  | sgr0,  exit_attribute_mode  | Turn off all attributes and colours. |
| [1m  | bold,  enter_bold_mode      | Enter bold mode.                     |
| [2m  | dim,   enter_dim_mode       | Enter half-bright mode.[^dim]        |
| [3m  | sitm,  enter_italics_mode   | Enter italic mode.[^sitm]            |
| [4m  | smul,  enter_underline_mode | Enter underline mode.                |
| [5m  | blink, enter_blink_mode     | Enter blinking mode.[^blink]         |
| [7m  | rev,   enter_reverse_mode   | Enter reverse video mode.            |
| [8m  | invis, enter_secure_mode    | Enter blank mode.[^invis]            |
| [9m  | smxx                        | Enter strikeout mode.                |

[^dim]: Except FreeBSD system console where it's `[30;1m`.
[^sitm]: Not super-widely supported, sometimes displays as reverse.
[^blink]: Often doesn't do anything (because it's annoying).
[^invis]: Characters can still be copy/pasted.

Colours are set with `setab` / `set_a_background` and `setaf` /
`set_a_foreground`; the format depends on which colour scheme you want to use.

### 16-colours
Pretty much everything supports 16 colours, unless explicitly disabled by the
user. The exact shade is determined by the terminal.

Escapes as «regular» «bright»:

| Foreground | Background | Colour  |
| ---------- | ---------- | ------- |
| [30m  [90m | [40m [100m | black   |
| [31m  [91m | [41m [101m | red     |
| [32m  [92m | [42m [102m | green   |
| [33m  [93m | [43m [103m | yellow  |
| [34m  [94m | [44m [104m | blue    |
| [35m  [95m | [45m [105m | magenta |
| [36m  [96m | [46m [106m | cyan    |
| [37m  [97m | [47m [107m | white   |

### 256-colours
Choose a colour from a [pre-defined table of 256 colours][tbl]. This is
supported on almost all current terminal emulators, unless explicitly disabled
by the user.

Where «C» is a number from 0 to 255:

    [38;5;«C»m   Foreground
    [48;5;«C»m   Background

[tbl]: https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit

### True colours
Use "true" RGB colours; this is supported on almost all current terminal
emulators, unless explicitly disabled by the user.

Where «R», «G», «B» are the red, green and blue values as decimal, 0 to 255:

	[38;2;«R»;«G»;«B»m   Foreground
	[48;2;«R»;«G»;«B»m   Background

Cursor movement
---------------

| Code      | Terminfo (short, long)  | Description                                     |
| ----      | ----------------------  | -----------                                     |
| [«R»;«C»H | cup,  cursor_address    | Set cursor position to «R», «C».[^cup]          |
| [«N»A     | cuu,  parm_up_cursor    | Move «N» lines up.                              |
| [«N»B     | cud,  parm_down_cursor  | Move «N» lines down.                            |
| [«N»C     | cuf,  parm_right_cursor | Move «N» characters to the right.               |
| [«N»D     | cub,  parm_left_cursor  | Move «N» characters to the left.                |
| 7         | sc,   save_cursor       | Save current cursor position.                   |
| 8         | rc,   restore_cursor    | Restore cursor to position of last save_cursor. |
| [6n       | u7,   user7             | Request cursor, returned as `\x1b[«R»;«C»R`     |

[^cup]: Top-left is 1;1

The «N» can be omitted in the above, in which case it will default to 1. For
`cup` the «R» and/or «C» can be omitted, and will default to 1.

Inserting and deleting text
-----------------------

| Code  | Terminfo (short, long) | Description                                        |
| ----  | ---------------------- | -----------                                        |
| [J    | ed,  clr_eos           | Clear from cursor to end of screen.                |
| [K    | el,  clr_eol           | Clear from cursor to end of line.                  |
| [1K   | el1, clr_bol           | Clear from cursor to beginning of line.            |
| [«N»M | dl,  parm_delete_line  | Delete «N» lines, moving all the lines below up.   |
| [«N»P | dch, parm_dch          | Delete «N» characters, moving all afterwards left. |
| [«N»L | il,  parm_insert_line  | Insert «N» lines, moving all lines below down.     |
| [«N»@ | ich, parm_ich          | Insert «N» characters, moving all after right.     |

The «N» can be omitted in the above, in which case it will default to 1.

Misc
----

| Code  | Terminfo (short, long)  | Description                                     |
| ----  | ----------------------  | -----------                                     |
| [?25l | civis, cursor_invisible | Make cursor invisible.[^civis]                  |
| [?25h | cnorm, cursor_normal    | Make cursor appear normal (undo civis).[^cnorm] |

[^civis]: mtm terminfo doesn't include the question mark, and Linux console adds another escape (`\x1b[?1c`). But for both this also works.
[^cnorm]: Has `[?12l` for some, but works without that on all; for FreeBSD terminfo has `[=0C` but that doesn't work (`[?25h` does)

Keys
----
Key input handling is kind of a mess, and this is where I really recommend using
a terminfo library if at all possible. This also avoids the whole
backspace/delete key confusion (less of an issue today than it used to be, but
still exists).

| Codes          | terminfo (short, long)  | Description                                         |
| -----          | ----------------------  | -----------                                         |
| [A OA          | kcuu1 key_up            | Arrow up                                            |
| [B OB          | kcud1 key_down          | Arrow down                                          |
| [C OC          | kcuf1 key_right         | Arrow right                                         |
| [D OD          | kcub1 key_left          | Arrow left                                          |
| [5~ [I         | kpp key_ppage           | PageUp                                              |
| [6~ [G         | knp key_npage           | PageDown                                            |
| [2~ [L         | kich1 key_ic            | Insert key                                          |
| [1~ [H OH [7~  | khome key_home          | Home key                                            |
| [4~ [F OF [8~  | kend key_end            | End key                                             |
| [11~ [M [[A OP | key_f1                  | F1                                                  |
| [12~ [N [[B OQ | key_f2                  | F2                                                  |
| [13~ [O [[C OR | key_f3                  | F3                                                  |
| [14~ [P [[D OS | key_f4                  | F4                                                  |
| [15~ [Q [[E    | key_f5                  | F5                                                  |
| [17~ [R        | key_f6                  | F6                                                  |
| [18~ [S        | key_f7                  | F7                                                  |
| [19~ [T        | key_f8                  | F8                                                  |
| [20~ [U        | key_f9                  | F9                                                  |
| [21~ [V        | key_f10                 | F10                                                 |
| [23~ [W        | key_f11                 | F11                                                 |
| [24~ [X        | key_f12                 | F12                                                 |
| \x7f \b        | kbs key_backspace       | Backspace key                                       |
| \x7f [3~       | kdch1 key_dc key_delete | Delete key; *usually* sends [3~, but some send \x7f |
| \x09           | -                       | Tab key                                             |
| \x0d           | -                       | Enter key                                           |

{% related_articles %}
- [github.com/termstandard/colors](https://github.com/termstandard/colors)
{% endrelated_articles %}
