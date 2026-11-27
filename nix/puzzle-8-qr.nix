{
  runCommand,
  qrencode,
  imagemagick,
}:

runCommand "puzzle-8-qr.png"
  {
    nativeBuildInputs = [
      qrencode
      imagemagick
    ];
  }
  ''
    # The QR's 263x269 size is part of the puzzle: both are primes and factors of the key. Level Q
    # keeps the URL at QR version 5 so the crop yields exactly that size.
    qrencode --foreground=FFFFFF --background=00000000 -s 6 -l Q -d 300 -o qr.png \
      https://maxslarsson.github.io/coding-puzzles/8/99d116.wasm
    magick qr.png -crop 263x269+4+1 +repage -define png:exclude-chunks=date,time \
      $out
  ''
