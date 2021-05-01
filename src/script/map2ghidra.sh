#!/bin/bash

# outputs a simple map like :

# _fputc 0x000010cb f
# _main 0x0000030c f
# _printf 0x00000331 f
# _errno ram:0x00000161 l

input=${1:-/dev/stdin}

# hold my beer
cat "$input" | tr -d $'\r|-' | sed -E 's/(^ +)//' | sed -E 's/ +/ /g' | grep -Ev '^$' \
	| awk '/Symbols \(sorted on address\)/{exit} /:code/{t="f";s=""} /:scode/{t="l";s=""} /:idata/{t="l";s="ram:"} /Symbols \(sorted on name\)/{p=1} p&&t { print $1" "s$2" "t }'\
	| head -n-1 | tail -n+6 | grep -Ev '^0x0 '