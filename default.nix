# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{
  pkgs,
  pkgs-24_05,
}:

let
  callCoqPackage = pkgs.coqPackages_8_15.callPackage;
in
rec {
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  dnsmasq-china-list_smartdns = pkgs.callPackage ./pkgs/dnsmasq-china-list_smartdns { };
  nsub = pkgs.callPackage ./pkgs/nsub { };
  sarasa-term-sc-nerd = pkgs.callPackage ./pkgs/sarasa-term-sc-nerd { };
  sarasa-term-sc-nerd-unhinted = pkgs.callPackage ./pkgs/sarasa-term-sc-nerd {
    variance = "unhinted";
  };
  sjtu-canvas-helper = pkgs.callPackage ./pkgs/sjtu-canvas-helper { };
  waylrc = pkgs.callPackage ./pkgs/waylrc { };

  # FIXME: wait for JDK25 fix
  Aya = pkgs.callPackage ./pkgs/Aya {
    jdk = pkgs-24_05.jdk22;
    gradle = pkgs.gradle_9;
  };
  ayaPackages = pkgs.lib.recurseIntoAttrs (
    pkgs.callPackage ./pkgs/top-level/agda-packages.nix {
      inherit Aya;
    }
  );
  inherit (ayaPackages) aya;
  inherit (ayaPackages) aya-minimal;

  coqPackages = {
    sets = callCoqPackage ./pkgs/coqPackages/sets { };
    fixedpoints = (callCoqPackage ./pkgs/coqPackages/fixedpoints) {
      inherit (coqPackages) sets;
    };
    monadlib = (callCoqPackage ./pkgs/coqPackages/monadlib) {
      inherit (coqPackages) sets fixedpoints;
    };
  };
}
