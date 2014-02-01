Vim motion on speed! [![Build Status](https://travis-ci.org/haya14busa/vim-easymotion.png?branch=master)](https://travis-ci.org/haya14busa/vim-easymotion)
=====

![Animated demonstration](https://f.cloud.github.com/assets/3797062/2039359/a8e938d6-899f-11e3-8789-60025ea83656.gif)

About authors
=====
- Kim Silkebækken (https://github.com/Lokaltog)
- haya14busa (https://github.com/haya14busa) (from version 2.0)

Now, EasyMotion project revived!
======
[haya14busa](https://github.com/haya14busa) took over the project from
version 2.0. Improved default motions, implemented new useful features,
and fixed some bugs.

Now, EasyMotion is completely

- **Well-behaved**. It is consistent with the default motions of Vim and works well in all mode including dot repeat support.
- **Configurable**. You can easily configure its behavior and map any key you want.
- **Sophisticated**. It provide bi-directional motion, showing two label feature, smartcase & smartsign sensitive feature, repeat motion, and 'increment search' motion which can jump to even off-screen and so forth.

haya14busa implemented a lot of new feature and modify default behaviors, but I carefully considered backward compatibility, so you can easily update and enjoy significant benefit!


Introduction
=====
EasyMotion provides a much simpler way to use some motions in vim. It
takes the `<number>` out of `<number>w` or `<number>f{char}` by
highlighting all possible choices and allowing you to press one key to
jump directly to the target.

When one of the available motions is triggered, all visible text
preceding or following the cursor is faded, and motion targets are
highlighted.

EasyMotion is triggered by one of the provided mappings.

Important notes
=====

### About the default bindings
**The default leader has been changed to `<Leader><Leader>` to avoid
conflicts with other plugins you may have installed.** This can easily be
changed back to pre-1.3 behavior by rebinding the leader in your vimrc:

```vim
map <Leader> <Plug>(easymotion-prefix)
```

All motions are now triggered with `<Leader>` by default, e.g.
`<Leader>s`, `<Leader>gE`.

### About SelectLines & SelectPhrase for fork version user
These features are not **motion**, so I separated them as different plugins.

- https://github.com/haya14busa/vim-easyoperator-line
- https://github.com/haya14busa/vim-easyoperator-phrase

Usage example
=====

Type `<Leader><Leader>w`(`<Plug>(easymotion-w)`) to trigger the word motion `w`. When the motion is
triggered, the text is updated (no braces are actually added, the text
is highlighted in red by default):

	<cursor>Lorem {a}psum {b}olor {c}it {d}met.

Press `c` to jump to the beginning of the word "sit":

	Lorem ipsum dolor <cursor>sit amet.

Similarly, if you're looking for an "o", you can use the `f` motion.
Type `<Leader><Leader>fo`, and all "o" characters are highlighted:

	<cursor>L{a}rem ipsum d{b}l{c}r sit amet.

Press `b` to jump to the second "o":

	Lorem ipsum d<cursor>olor sit amet.

Jeffrey Way of Nettuts+ has also [written
a tutorial](http://net.tutsplus.com/tutorials/other/vim-essential-plugin-easymotion/)
about EasyMotion.


New feature from 2.0
-----
## Two key combo
1. Use one - two character key jump. Display two keys if one-character key is not enough, so you can see what two keys to type without waiting after pressing the first key.

## Support bidirectional motion
It provide forward-backward (bidirectional) search feature to all motion.
(e.g. `<Plug>(easymotion-s)`, `<Plug>(easymotion-bd-w)` and so forth)

You can jump forward or backward at the same time by `<Leader>s`.
One useful trick is to map `nmap s <Plug>(easymotion-s)` to use `s` instead and save one keystroke!

## 2 key find motion
EasyMotion provide 2-key find motions like vim-seek/vim-sneak. (e.g. `<Plug>(easymotion-s2)`)

![2-key-find-motion](https://f.cloud.github.com/assets/3797062/2039612/7cafcec8-89a5-11e3-8f2c-5f26a6b83efd.gif)
```vim
" Gif config
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)
```

## 'n' key find motion
EasyMotion also provide 'n' key find motion like default 'search' motion of Vim.

- Incremental highlight
- Search off-screen by `<Tab>` & `<S-Tab>`

Scroll by `<Tab>` key (`<S-Tab>` is backward) and `<CR>` to execute.
![n-key-motion-scroll](https://f.cloud.github.com/assets/3797062/2039254/4fbf7276-899e-11e3-9bf3-1e446cabc097.gif)

Completely replace default search of Vim with EasyMotion example.
![replace-search](https://f.cloud.github.com/assets/3797062/2039751/64b72bd8-89a8-11e3-80ea-2a6b578040b2.gif)

```vim
" Gif config
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
```

## Within line motion
Every motion also support within line motion.(e.g. `<Plug>(easymotion-sl)`,
`<Plug>(easymotion-bd-wl)`, etc...)

These motion matches only current line.

Example: these motion extend `hjkl` motion!
```vim
" Gif config
map <Leader>h <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>l <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
```

![hjkl-motoin](https://f.cloud.github.com/assets/3797062/2039413/d8b32ab2-89a0-11e3-894f-3e81db084cfd.gif)

## Find target by smartcase & smartsign!

Matching target keys by smartcase. You can type targets more easily.

In find motion(e.g. `<Plug>(easymotion-s)`), type 'v' and matches 'v' & 'V',
and 'V' matches only 'V'.

Add following description in your vimrc:

	let g:EasyMotion_smartcase = 1

Default:0

Matching target keys by smartsign. You can type targets more easily.

In find motion, type '1' and matches '1' & '!', and '!' matches only '!'.

Add following description in your vimrc:

```vim
let g:EasyMotion_use_smartsign_us = 1 " US layout
" or
let g:EasyMotion_use_smartsign_jp = 1 " JP layout
```

## Migemo feature (for Japanese user)
Easymotion can match multibyte Japanese characters with a alphabet input.
For example, `<Leader><Leader>sa` can search 'あ'.
This feature doesn't require cmigemo because Easymotion includes regex
patterns generated by cmigemo. However if you installed `cmigemo`,
2-key and 'n' key find motion also support migemo feature.

Add following description in your vimrc:

```vim
let g:EasyMotion_use_migemo = 1
```

Default:0

## Repeat motion
**Repeat last motion:** `<Plug>(easymotion-repeat)`

**Repeat last find motion:**

In find motion(e.g. `<Plug>(easymotion-s)`), to type `<CR>` without
input characters invoke last find motion.

**Jump to next/previous match even off-screen:**

`<Plug>(easymotion-next)` & `<Plug>(easymotion-prev)`

**Dot repeat support:** 

Require https://github.com/tpope/vim-repeat

You can use EasyMotion in operator-pending and press `.` to repeat!
It is well-behaved, consistent with default behavior of Vim.

![repeat-motion](https://f.cloud.github.com/assets/3797062/2039538/0aef66aa-89a4-11e3-8242-c27a5208cfca.gif)

```vim
" Gif config

" Require tpope/vim-repeat to enable dot repeat support
" Jump to anywhere with only `s{char}{target}`
" `s<CR>` repeat last find motion.
nmap s <Plug>(easymotion-s)
" Bidirectional & within line 't' motion
omap t <Plug>(easymotion-bd-tl)
" Use uppercase target labels and type as a lower case
let g:EasyMotion_use_upper = 1
 " type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1
```

See `:help easymotion.txt` for more detail!

Pull requests are welcome including my English check! :)

