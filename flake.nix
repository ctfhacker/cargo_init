{
  description = "Basic initialization binary to init a Rust project with envrc and shell.nix";

  inputs = {
  };

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
}
