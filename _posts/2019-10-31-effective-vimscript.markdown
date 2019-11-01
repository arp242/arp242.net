---
layout: post
title: "Effective VimScript"
---

The VimScript language is rather idiosyncratic, and because few people – if
anyone – uses it to make a living, not many people learn it in-depth.

This document gives tips for writing VimScript code.

General
-------

- Use **`is` instead of `==`**. Like PHP and JavaScript `==` will coerce types
  (`'0' == 0`). The `is` operator doesn't, like `===`. You do need to be careful
  when comparing entire lists or dicts, since `is` will test *identity* rather
  than *value*.

  For string comparison **use `is#` or `is?`**, as the behaviour of `is` and
  `==` are affected by the `ignorecase` setting. In general, it's a good
  practice to just always use `is#` instead of `==`; it will work fine for other
  types as well.

<!-- Controversial, and may not work like I think it did. Comment out for now
     until I have more time to properly investigate.
- Use **explicit variable scope**. `let foo = 1` can refer to `l:foo`, `s:foo`,
  or `g:foo`. You should use explicit scope for the same reason as you should
  always use `var` or `let` in JavaScript.
-->

- **`abort` functions**. Without it Vim will keep executing code after an error,
  which rarely what you want. Use the `abort` keyword to abort function
  execution on error (e.g. `fun! MyFun() abort`). You can still use `try ..
  catch` to recover from errors.

- Use **`try .. finally`** A common pattern is something like:

      let l:old_setting = &setting

      [.. do work ..]

      let &setting = l:old_setting

  But the resetting of `&setting` will fail if the code returns in the "do work"
  path, either because of a `return` or because of an error.

  The `finally` block will always get executed:

      try
        let l:old_setting = &setting

        [.. do work ..]
      finally
        let &setting = l:old_setting
      endtry

  This also applies to saving and restoring the view with
  `winsaveview()`/`winrestview()`.

- Be careful when **modifying lists and dicts**. Many operations change the
  value of a list or dict *in place* but *also* return the new value. This leads
  to code like:

      let g:plugin_default = ['a', '_a', 'b', '_b']

      fun! s:do_stuff() abort
          let l:filtered = filter(g:plugin_default, {_, v -> v[0] isnot# '_'})
          [..]
      endfun

  `l:filtered` will be `['a', 'b']`, but so will `g:plugin_default`, which is
  probably not what you wanted! Use `copy()` or `deepcopy()` instead:

      let l:filtered = filter(copy(g:plugin_default), {_, v -> v[0] isnot# '_'})

  This is also an issue when passing lists or dicts as arguments; since they're
  passed by *reference* rather than value, modifications are not local to just
  the function:

      fun! Test(list_arg)
          let l:mapped = map(a:list_arg, {_, v -> 'XXX-' . l:v})
          [..]
      endfun

      :let l = ['hello']
      :call Test(l)
      :echo l
      ['XXX-hello']

- Prefer **`printf()` over string concatenation**; e.g. `echo printf('x: %s',
  [42])` will work, whereas `echo 'x: ' . [42]` will give you a useless error.

- Use **`execute()`** rather than `redir`. It's a lot less clumsy. Many older
  Stack Overflow answers and the like recommend `:redir`, but `execute()` is
  available since Vim 7.4.2008 (July 2016).


Plugins
-------

- **Scope to filetype**. Quite a few plugins that work on only a single filetype
  exist globally. There is no reason to have a `:PythonFrob` when editing Ruby
  files.

  Moving `plugin/myplugin.vim` to `ftplugin/python.vim` and adding `buffer` to
  `:command` and `:map` is often all that's needed; this will only load the file
  when that filetype is set and scope the commands and mappings to the buffer.
  See `:help ftplugin` for details.

  Alternatively, you can use a `FileType` autocmd if your plugin works for many
  different filetypes.

- Use **autoload**. VimScript in the `plugin` and `ftplugin` directory will
  always be loaded on startup. Code in the `autoload` directory will be loaded
  on first use.

  This also allows some rudimentary modularisation instead of putting everything
  in the global namespace (e.g. `plugin#foo#fun()` instead of `PluginFooFun()`).
  See `:help autoload`.

  Using `plugin` might be okay if your plugin is very small though.

- Make **functions script-local** when possible; not everything needs to be
  exported. Consider using `s:name()` when it's only used in the current script
  context *and* isn't useful for your plugin users.

  Note: you can use `<SID>` in mappings, e.g. `nnoremap x <SID>fun()<CR>`.

- There are a few different approaches to **plugin settings**, the "best way"
  depends on the plugin and personal preference:

  1. Define the default on use:

         call do_something(get(g:, 'plugin_setting', 'default value'))

     Advantage: it's the simplest approach.

     Downside: you'll have to define the default multiple times if used more
     than once. Many plugins don't, so it can still be a good option for small
     plugins.

     Another downside is that users can't inspect current value. Want to know
     what `g:plugin_setting` is? You'll have to read the docs and *hope* they're
     correct.

  2. Define the defaults on startup:

         let g:plugin_setting = get(g:, 'plugin_setting', 'default value')

     Advantage: one location for the default values, allows users to inspect
     values.

     Downsides: may add a lot of global variables.

  <!--
  3. Use a wrapper:

         fun! plugin#config#setting()
            return get(g:, 'plugin_setting', 'default value')
         endfun

         call do_something(plugin#config#setting())

     Advantage: 

     Downside: can't inspect current value, needs a new function per variable.
  -->


  In general, I would recommend the first approach for small plugins and the
  second one for larger ones.

  Other considerations:

  - Always prefix variable names with the name of your plugin.
  - Make sure to document all settings and add appropriate help tags. This means
    people can easily discover documentation with `:help g:plugin_<Tab>`.

- **Plugin mappings**: the right strategy depends on the plugin and size. The
  two most important things are to not override people's existing mappings and
  allowing people to override your default mappings.

  To ensure you're not overriding existing mappings you can use `mapcheck()` or
  `hasmapto()`. `mapcheck()` will check if key is mapped to anything, so you
  won't override existing mappings:

      :echo mapcheck('<F1>', 'n')
      :set wrap!<CR>

      :echo mapcheck('<F2>', 'n')
      (empty string)

      if mapcheck('<F1>', 'n') is# ''
        nnoremap <F1> :call myplugin#action()<CR>
      endif

  And `hasmapto()` checks if the given commands appears in the right-hand-side
  of a mapping, allowing you to map an action only if the user didn't map it to
  something else:

      :echo hasmapto(':set wrap!<CR>', 'n')
      1

      :echo hasmapto(':set cursorline!<CR>', 'n')
      0

      if !hasmapto('myplugin#action', 'n')
        nnoremap <Leader>d :call myplugin#action()<CR>
      endif

  In general use `hasmapto()` if mappings are essential to your plugin and
  `mapcheck()` if they're just bonus features.

  Make sure your plugin has a way to disable mappings altogether with a setting
  (`g:plugin_nomap`) unless they're an essential part of your plugin.

  You can make it easy for people to map actions by abstracting them with
  `<Plug>` mappings; first create a mapping to `<Plug>(name)`:

      nnoremap <Plug>(myplugin-action) :call myplugin#action('arg', 2)<CR>

  And users can map that without worrying about the internal details of the
  mapping:

      nmap <Leader>d <Plug>(myplugin-action)

  See `:help using-<Plug>`.

  Adding `g:plugin_map` variable to control which action gets mapped to which
  key can be helpful for some plugins, for example when several mappings all
  start with the same prefix; changing `g:plugin_map_prefix = ';'` is easier
  than remapping 7 actions.
