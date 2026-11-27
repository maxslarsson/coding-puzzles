{
  runCommand,
  binaryen,
  wabt,
  util-linux,
}:

runCommand "puzzle-6-hexdump.txt"
  {
    nativeBuildInputs = [
      binaryen
      wabt
      util-linux
    ];
  }
  ''
    wasm-as ${../puzzles/6/puzzle.wat} -o 6.wasm
    wasm-strip 6.wasm
    gzip -9 -n -c 6.wasm | hexdump -e '16/1 "%02x " "\n"' > $out
  ''
