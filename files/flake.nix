{
  description = "Snapchange development environment";

  # Flake inputs
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";

    # Rust overlay for Rust nightly
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # Flake utils for eachDefaultSystem
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Flake outputs
  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem(system: 
      let
        # Use the rust overlay to use Rust nightly
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        myrust = pkgs.rust-bin.nightly.latest.default.override {
          extensions = [ "rust-src "]
          targets = []
        };
      in
        with pkgs; {
          devShells.default = mkShell {
              # LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.stdenv.cc.cc ];

              packages = [
                # Python
                (python312.withPackages (ps: with ps; [
                  virtualenv 
                  pip 
                  ipython
                  ipdb
                ]))

                # Rust nightly
                myrust
                rust-analyzer
              ];

              shellHook = ''
                # Install binaryninja into a local virtual envirionment
                # If the virtual environment has not been created, create it
                if [ ! -d "./.venv" ]; then
                  BINJA=$(readlink $(which binaryninja))
                  BINJA_PATH=$(dirname $BINJA)/..

                  python3 -m venv ./.venv;
                  source ./.venv/bin/activate;

                  python3 $BINJA_PATH/opt/scripts/install_api.py --install-on-pyenv
                else
                  # If the virtual environment exists, use it
                  source ./.venv/bin/activate
                fi
              '';
            };
          });
}
