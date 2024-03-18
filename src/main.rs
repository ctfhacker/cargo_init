use std::path::Path;

fn main() {
    const ENVRC: &'static str = include_str!("../.envrc");
    const SHELLNIX: &'static str = include_str!("../shell.nix");
    const GITIGNORE: &'static str = include_str!("../.gitignore");

    let dir = std::env::args()
        .nth(1)
        .expect("USAGE: cargo_init <DIRECTORY>");

    let dir = Path::new(&dir);

    if std::fs::create_dir_all(dir).is_err() {
        println!("ERROR: Directory already exists");
        return;
    }

    // Execute `cargo init` in the new directory
    let _ = std::process::Command::new("nix-shell")
        .args([
            "-p",
            "cargo",
            "--quiet",
            "--run",
            &format!("cargo init --quiet {}", dir.to_str().unwrap()),
        ])
        .output()
        .expect("Failed to cargo init");

    // Write the wanted files into the new project
    let _ = std::fs::write(dir.join(".envrc"), ENVRC);
    let _ = std::fs::write(dir.join("shell.nix"), SHELLNIX);
    let _ = std::fs::write(dir.join(".gitignore"), GITIGNORE);

    // `direnv allow` in the new directory
    std::process::Command::new("direnv")
        .current_dir(dir)
        .args(["allow"])
        .spawn()
        .expect("Failed to direnv allow");
}
