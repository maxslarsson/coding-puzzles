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
