#!/bin/sh

# Create the QR code. Its 263x269 size is part of the puzzle (both are primes), and level Q keeps
# the URL at QR version 5 so the crop below still yields exactly that size.
qrencode --foreground=FFFFFF --background=00000000 -s 6 -l Q -d 300 -o ../../../lib/assets/8/qr.png "https://maxslarsson.github.io/coding-puzzles/8/puzzle.wasm"
convert ../../../lib/assets/8/qr.png -crop 263x269+4+1 +repage ../../../lib/assets/8/qr.png

# Create the web assembly file
wasm-as puzzle.wat -o ../../../../static/8/puzzle.wasm
wasm-strip ../../../../static/8/puzzle.wasm
