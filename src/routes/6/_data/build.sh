#!/bin/sh

wasm-as puzzle.wat -o puzzle.wasm
wasm-strip puzzle.wasm
gzip -9 -f -k puzzle.wasm

hexdump -e '16/1 "%02x " "\n"' puzzle.wasm.gz >> ../../../../static/6/hexdump.txt

#echo 'text 8,0 "' > hexdump.txt
#hexdump -e '16/1 "%02x " "\n"' puzzle.wasm.gz >> hexdump.txt
#echo '"' >> hexdump.txt
#
#convert -size 1160x616 xc:transparent -font "JetBrains-Mono-Regular-Nerd-Font-Complete-Mono" -pointsize 40 -fill white -draw @hexdump.txt ../../../../static/6/file.png