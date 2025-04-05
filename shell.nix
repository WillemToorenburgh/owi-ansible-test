with (import <nixpkgs> {});
  mkShell {
    packages = [
      pkgs.ansible
      pkgs.ansible-lint
      pkgs.python312Packages.paramiko
    ];
  }
