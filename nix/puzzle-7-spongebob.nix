{ runCommand, python3 }:

runCommand "puzzle-7-spongebob.png"
  {
    nativeBuildInputs = [ (python3.withPackages (ps: [ (ps.callPackage ./stegano.nix { }) ])) ];
  }
  ''
    stegano-lsb hide -i ${../puzzles/7/spongebob.png} -m 99d116 -o $out
  ''
