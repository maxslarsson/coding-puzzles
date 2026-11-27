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
    # The QR's 263x269 size is part of the puzzle: both are primes and factors of the key. The URL
    # is short enough to fit a smaller version at lower levels, so level H (version 5 holds 44
    # bytes) pins it at version 5 and the crop yields exactly that size.
    qrencode --foreground=FFFFFF --background=00000000 -s 6 -l H -d 300 -o qr.png \
      https://puzzles.maxlarsson.dev/8/99d116.wasm
    magick qr.png -crop 263x269+4+1 +repage -define png:exclude-chunks=date,time \
      $out
  ''
