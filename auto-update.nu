#!/usr/bin/env -S nix shell nixpkgs#nushell nixpkgs#nix-update --command nu

let SYSTEM = (nix eval --impure --raw --expr 'builtins.currentSystem')
let PKGS = (nix eval --raw $".#packages.($SYSTEM)" --apply 'attrs: builtins.toString (builtins.attrNames attrs)' | split row ' ')
let EXCLUDED_PKGS = [ aya aya-minimal sarasa-term-sc-nerd-unhinted ]

let UPDATE_ARGS = {
    # custom version format
    Aya: ["--version-regex=v(.*)"]
    sjtu-canvas-helper: ["--version-regex=app-v(.*)"]
    waylrc: ["--version-regex=v(.*)"]
    # unstable update
    dnsmasq-china-list_smartdns: ["--version=branch"]
    nsub: ["--version=branch"]
}

def update_package [pkg: string, verbose: bool] {
    print $"Updating ($pkg) ..."

    # Check if package file exists
    let pkg_file = $"pkgs/($pkg)/default.nix"

    let hash_before = (open $pkg_file | hash sha256)

    let args = ($UPDATE_ARGS | get -o $pkg | default [])

    let update_result = try {
        if ($args | is-empty) {
            ^nix-update --flake $pkg | complete
        } else {
            ^nix-update --flake $pkg ...$args | complete
        }
    } catch { |e|
        print $"😾 Error updating ($pkg): ($e.msg)"
        return
    }

    if $update_result.exit_code != 0 {
        print $"😾 Error updating ($pkg): program exited with error ($update_result.exit_code):"
        print $update_result.stderr
        return
    } else if $verbose {
        if not ($update_result.stdout | is-empty) {
            print $"nix-update output for ($pkg):"
            print $update_result.stdout
        }
        if not ($update_result.stderr | is-empty) {
            print $"nix-update stderr for ($pkg):"
            print $update_result.stderr
        }
    }

    let hash_after = (open $pkg_file | hash sha256)

    if $hash_before == $hash_after {
        print $"🐖 No update needed for ($pkg)."
    } else {
        print $"😺 Successfully updated ($pkg)."
    }
}

def main [--verbose (-v) = false] {
    for pkg in $PKGS {
        if $pkg not-in $EXCLUDED_PKGS {
            update_package $pkg $verbose
        }
    }
}
