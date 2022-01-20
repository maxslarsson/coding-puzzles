#!/bin/sh

# Create the QR code
qrencode --foreground=FFFFFF --background=00000000 -s 6 -l H -d 300 -o ../../../../static/8/qr.png "https://maxslarsson.github.io/8/puzzle.wasm"
convert ../../../../static/8/qr.png -crop 263x269+4+1 ../../../../static/8/qr.png

# Create the web assembly file
wasm-as puzzle.wat -o ../../../../static/8/puzzle.wasm
wasm-strip ../../../../static/8/puzzle.wasm
