# Summary

EasyMotion provides a much simpler way to use some motions in vim. It 
takes the `<number>` out of `<number>w` or `<number>f{char}` by 
highlighting all possible choices and allowing you to press one key to 
jump directly to the target.

When one of the available motions is triggered, all visible text 
preceding or following the cursor is faded, and motion targets are 
highlighted.

EasyMotion is triggered manually or by one of the provided mappings.

Example:

	<cursor>Lorem ipsum dolor sit amet.

If the word motion `w` is triggered with the default mapping 
`<Leader>w`, the text is updated (no braces are actually added, the 
letters are highlighted in red by default):

	<cursor>Lorem {a}psum {b}olor {c}it {d}met.

Press `c` to jump to the beginning of the word "sit":

	Lorem ipsum dolor <cursor>sit amet.

And that's it!

## Animated demonstration

![Animated demonstration](http://oi54.tinypic.com/2yysefm.jpg)
