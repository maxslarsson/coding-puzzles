{
  writeShellApplication,
  coreutils,
  git,
  puzzle-4-bytes,
  puzzle-6-hexdump,
  puzzle-7-spongebob,
  puzzle-8-qr,
  puzzle-8-wasm,
}:

writeShellApplication {
  name = "generate-puzzle-assets";
  runtimeInputs = [
    coreutils
    git
  ];
  text = ''
    cd "$(git rev-parse --show-toplevel)"
    install -Dm644 ${puzzle-4-bytes} static/4/56382.bytes
    install -Dm644 ${puzzle-6-hexdump} static/6/22ba57.txt
    install -Dm644 ${puzzle-7-spongebob} src/lib/assets/7/spongebob.png
    install -Dm644 ${puzzle-8-qr} src/lib/assets/8/qr.png
    install -Dm644 ${puzzle-8-wasm} static/8/99d116.wasm
  '';
}
