with (import <nixpkgs> {});
  mkShell {
    packages = [
      pkgs.ansible
      pkgs.ansible-lint
    ];
  }
