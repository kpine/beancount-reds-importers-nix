{
  description = "Importers for various institutions for Beancount";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

    flake-utils.url = "github:numtide/flake-utils";

    beancount-reds-importers-src = {
      url = "github:redstreet/beancount_reds_importers/1.0.0";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      beancount-reds-importers-src,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # Derive the version from the ref pinned in the flake input URL
        version =
          (builtins.fromJSON (builtins.readFile ./flake.lock))
          .nodes.beancount-reds-importers-src.original.ref;
        python = pkgs.python3;
        beancount-reds-importers = python.pkgs.callPackage ./pkgs/beancount-reds-importers/package.nix {
          inherit beancount-reds-importers-src version;
        };
      in
      {
        packages = {
          beancount-reds-importers = beancount-reds-importers;
          default = beancount-reds-importers;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            (python.withPackages (ps: [
              beancount-reds-importers
            ]))
          ];
        };

        formatter = pkgs.nixfmt-tree;
      }
    );
}
