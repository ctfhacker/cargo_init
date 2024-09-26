{
  description = "Basic initialization binary to init a Rust project with envrc and shell.nix";

  inputs = {
  };

<<<<<<< HEAD
  outputs = { ... }: {
    templates.rust = {
      path = ./files;
      description = "Default rust template";
      welcomeText = ''
      # Getting started
      - Run `nix develop`
      '';
    };
  };
||||||| 2e5b070
  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        rustPackage = pkgs.rustPlatform.buildRustPackage {
          pname = "cargo_init";
          version = "0.1.0";
          src = ./.;
          cargoSha256 = "sha256-0WMGBzoFVoXZwL7Y7KGA+FVK+19bgLD2P7u/Tm31N3o="; # Replace this with the actual hash
          buildInputs = [ ]; # Add dependencies here
        };
      in
      rec {
        packages.default = rustPackage;
        defaultPackage = rustPackage;

        apps.default = flake-utils.lib.mkApp { 
          drv = packages.default; 
        };

        /*
        apps.cargo_init = {
          type = "app";
          program = "${self.packages.system.cargo_init}/bin/cargo_init}";
        };
        */
      });
=======
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        rustPackage = pkgs.rustPlatform.buildRustPackage {
          pname = "cargo_init";
          version = "0.1.0";
          src = ./.;
          cargoSha256 = "sha256-0WMGBzoFVoXZwL7Y7KGA+FVK+19bgLD2P7u/Tm31N3o="; # Replace this with the actual hash
          buildInputs = [ ]; # Add dependencies here
        };
      in
      rec {
        packages.default = rustPackage;
        defaultPackage = rustPackage;

        apps.default = flake-utils.lib.mkApp { 
          drv = packages.default; 
        };

        /*
        apps.cargo_init = {
          type = "app";
          program = "${self.packages.system.cargo_init}/bin/cargo_init}";
        };
        */
      });
>>>>>>> 3b31f9c23391523bc260a65d63f5eeedce8e45c1
}
