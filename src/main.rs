use std::path::Path;

fn main() {
    const ENVRC: &'static str = include_str!("../.envrc");
    const SHELLNIX: &'static str = include_str!("../shell.nix");

    let dir = std::env::args()
        .nth(1)
        .expect("USAGE: cargo_init <DIRECTORY>");

    let dir = Path::new(&dir);

    if std::fs::create_dir_all(dir).is_err() {
        println!("ERROR: Directory already exists");
        return;
    }

    let _ = std::fs::write(dir.join(".envrc"), ENVRC);
    let _ = std::fs::write(dir.join("shell.nix"), SHELLNIX);

    std::process::Command::new("direnv")
        .current_dir(dir)
        .args(["allow"])
        .spawn()
        .expect("Failed to direnv allow");

    std::process::Command::new("nix-shell")
        .args([
            "-p",
            "cargo",
            "--run",
            &format!("cargo init {}", dir.to_str().unwrap()),
        ])
        .spawn()
        .expect("Failed to cargo init");
}
