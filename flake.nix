{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, ... }@inputs:

    let
      # .node-version must hold a bare major (e.g. 24); nixpkgs only ships nodejs_<major>
      nodeMajor = inputs.nixpkgs.lib.trim (builtins.readFile ./.node-version);

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          let
            pkgs = import inputs.nixpkgs { inherit system; };
          in
          f pkgs
        );
    in
    {
      packages = forEachSupportedSystem (pkgs: {
        puzzle-4-bytes = pkgs.callPackage ./nix/puzzle-4-bytes.nix { };
        puzzle-6-hexdump = pkgs.callPackage ./nix/puzzle-6-hexdump.nix { };
        puzzle-7-spongebob = pkgs.callPackage ./nix/puzzle-7-spongebob.nix { };
        puzzle-8-qr = pkgs.callPackage ./nix/puzzle-8-qr.nix { };
        puzzle-8-wasm = pkgs.callPackage ./nix/puzzle-8-wasm.nix { };
      });

      apps = forEachSupportedSystem (pkgs: {
        generate-puzzle-assets = {
          type = "app";
          program = pkgs.lib.getExe (
            pkgs.callPackage ./nix/generate-puzzle-assets.nix self.packages.${pkgs.stdenv.hostPlatform.system}
          );
          meta.description = "Generate the puzzle assets into static/ and src/lib/assets/";
        };
      });

      devShells = forEachSupportedSystem (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            pkgs."nodejs_${nodeMajor}"
            # pnpm self-switches to the version in package.json's packageManager
            pnpm
            vtsls
            svelte-language-server
          ];
        };
      });
    };
}
