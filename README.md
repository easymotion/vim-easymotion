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

The default bindings may conflict with other plugins you have installed, 
e.g. Command-T. Please read the docs about the default bindings, it's 
easy to rebind the EasyMotion keys or rebind the leader key in order to 
"namespace" the plugin.

You can rebind the leader key in your vimrc:

	let g:EasyMotion_leader_key = '<Leader>m'

All the motions will now be triggered with `<Leader>m` first, e.g. 
`<Leader>mt`, `<Leader>mgE`. You can also remap single motions:

	let g:EasyMotion_mapping_t  = '_t'
	let g:EasyMotion_mapping_gE = '_gE'

## Usage example

Type `<Leader>w` to trigger the word motion `w`. When the motion is 
triggered, the text is updated (no braces are actually added, the text 
is highlighted in red by default):

	<cursor>Lorem {a}psum {b}olor {c}it {d}met.

Press `c` to jump to the beginning of the word "sit":

	Lorem ipsum dolor <cursor>sit amet.

Similarly, if you're looking for an "o", you can use the `f` motion.  
Type `<Leader>fo`, and all "o" characters are highlighted:

	<cursor>L{a}rem ipsum d{b}l{c}r sit amet.

Press `b` to jump to the second "o":

	Lorem ipsum d<cursor>olor sit amet.

Jeffrey Way of Nettuts+ has also [written 
a tutorial](http://net.tutsplus.com/tutorials/other/vim-essential-plugin-easymotion/) 
about EasyMotion.

## Animated demonstration

![Animated demonstration](http://oi54.tinypic.com/2yysefm.jpg)
