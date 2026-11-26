{ runCommand, python3 }:

runCommand "puzzle-4-bytes"
  {
    nativeBuildInputs = [ python3 ];
  }
  ''
    python3 ${../puzzles/4/encode.py} ${../puzzles/4/target.png} uNaFrAId $out
  ''
