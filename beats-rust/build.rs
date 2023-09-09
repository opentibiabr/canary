use std::fs;

fn main() {
    // Mova a biblioteca para o diretório raiz
    if let Err(e) = fs::rename("./target/release/beats.lib", "./beats.lib") {
        println!("Falha ao mover a biblioteca: {}", e);
    }

    println!("biblioteca");
}
