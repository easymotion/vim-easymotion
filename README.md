# Modifications to Lokaltog's EasyMotion
1. Use one - two character key jump. Display two keys if one-character key is not enough, so you can see what two keys to type without waiting after pressing the first key.
2. Added forward-backward search (bidirectional) search. You can jump forward or backward at the same time. `<Leader>s`. One useful  trick is to map `nmap <SPACE> <leader>s` and `vmap <SPACE> <leader>s` to use space bar instead and save one keystroke!
3. Added SelectLines function which allows you to select any range of lines using two consecutive easymotion calls. Default mappings are `cl, dl, vl, yl`. To yank a single line you can either type the same character(s) twice, or use '.' character. E.g. `vlb.` will select the line with character 'b'. Note: to promote good Vim habits, you should learn standard movement commands like `}}, vi(, va(, %, ][, ]], [(, etc.` before resorting to this function. 
4. (Experimental) Added SelectPhrase function which allows you to make selection between any two characters. Default mapping are `cp, dp, vp, yp`. Example usage: type `vp` then press two input characters. Now the two input characters will be highlight on the same screen, and you can then type two combos to make selection.

## Animated demonstration

Two-key combo

![two-character key](http://homes.cs.washington.edu/~supasorn/easymotion.gif)

Select lines using `vl`

![two-character key](http://homes.cs.washington.edu/~supasorn/easymotion2.gif)

Yank lines using `yl`. You can copy lines without moving cursor back and forth between line you want to yank and line you want to paste.

![two-character key](http://homes.cs.washington.edu/~supasorn/easymotion3.gif)

This is an alpha version, which breaks multi-byte support, and others.
# Introduction

EasyMotion provides a much simpler way to use some motions in vim. It
takes the `<number>` out of `<number>w` or `<number>f{char}` by
highlighting all possible choices and allowing you to press one key to
jump directly to the target.

When one of the available motions is triggered, all visible text
preceding or following the cursor is faded, and motion targets are
highlighted.

EasyMotion is triggered by one of the provided mappings.

# Important notes about the default bindings

**The default leader has been changed to `<Leader><Leader>` to avoid 
conflicts with other plugins you may have installed.** This can easily be 
changed back to pre-1.3 behavior by rebinding the leader in your vimrc:

	let g:EasyMotion_leader_key = '<Leader>'

All motions are now triggered with `<Leader><Leader>` by default, e.g.
`<Leader><Leader>t`, `<Leader><Leader>gE`.

## Usage example

Type `<Leader><Leader>w` to trigger the word motion `w`. When the motion is
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

## Animated demonstration

![Animated demonstration](http://oi54.tinypic.com/2yysefm.jpg)
