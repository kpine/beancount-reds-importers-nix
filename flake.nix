{
  description = "Importers for various institutions for Beancount";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    beancount-reds-importers-src = {
      type = "github";
      owner = "redstreet";
      repo = "beancount_reds_importers";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, beancount-reds-importers-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        beancount-reds-importers = python.pkgs.buildPythonPackage {
          pname = "beancount-reds-importers";
          version = "0.0.0-dev";
          pyproject = true;

          src = beancount-reds-importers-src;

          build-system = with python.pkgs; [
            hatchling
            uv-dynamic-versioning
          ];

          dependencies = with python.pkgs; [
            beancount
            beangulp
            click
            click-aliases
            dateparser
            loguru
            ofxparse
            openpyxl
            packaging
            pdfplumber
            petl
            requests
            tabulate
            tqdm
            xlrd
          ];

          nativeCheckInputs = with python.pkgs; [ pytestCheckHook ];

          pythonImportsCheck = [ "beancount_reds_importers" ];

          meta = {
            homepage = "https://github.com/redstreet/beancount_reds_importers";
            changelog = "https://github.com/redstreet/beancount_reds_importers/blob/main/CHANGELOG.md";
            description = "Simple ingesting tools for Beancount";
            longDescription = ''
              A double-entry bookkeeping computer language that lets you define
              financial transaction records in a text file, read them in memory,
              generate a variety of reports from them, and provides a web interface.
            '';
            license = pkgs.lib.licenses.gpl3Only;
          };
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
      }
    );
}
