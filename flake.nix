{
  description = "My personal NUR repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-manifest = {
      url = "https://static.rust-lang.org/dist/channel-rust-nightly.toml";
      flake = false;
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      fenix,
      rust-manifest,
      ...
    }:
    # See https://flake.parts/module-arguments for module arguments
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.pre-commit-hooks.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        {
          config,
          self',
          pkgs,
          lib,
          system,
          ...
        }:
        let
          rustToolchain = (fenix.packages.${system}.fromManifestFile rust-manifest).minimalToolchain;
          rustPlatform = pkgs.makeRustPlatform {
            cargo = rustToolchain;
            rustc = rustToolchain;
          };
        in
        {
          treefmt = {
            projectRootFile = "flake.nix";
            settings.global.excludes = [
              ".github/dependabot.yml"
              "garnix.yaml"
              "LICENSE"
            ];

            programs = {
              actionlint.enable = true;
              deadnix.enable = true;
              nixfmt.enable = true;
              statix.enable = true;
              zizmor.enable = true;
            };
          };

          # https://flake.parts/options/git-hooks-nix.html
          # Example: https://github.com/cachix/git-hooks.nix/blob/master/template/flake.nix
          pre-commit.settings.addGcRoot = true;
          pre-commit.settings.hooks = {
            commitizen.enable = true;
            eclint.enable = true;
            markdownlint.enable = true;
            treefmt.enable = true;
          };

          legacyPackages = import ./default.nix { inherit pkgs rustPlatform; };

          packages = lib.filterAttrs (_: v: lib.isDerivation v) self'.legacyPackages;

          devShells.default = pkgs.mkShell {
            inputsFrom = [
              config.treefmt.build.devShell
              config.pre-commit.devShell
            ];

            shellHook = ''
              echo 1>&2 "Welcome to the development shell!"
            '';

            packages = [ pkgs.nushell ];
          };
        };
    };
}
