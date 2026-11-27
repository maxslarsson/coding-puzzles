{
  runCommand,
  binaryen,
  wabt,
}:

runCommand "puzzle-8.wasm"
  {
    nativeBuildInputs = [
      binaryen
      wabt
    ];
  }
  ''
    wasm-as ${../puzzles/8/puzzle.wat} -o $out
    wasm-strip $out
  ''
