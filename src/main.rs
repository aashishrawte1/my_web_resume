use actix_files as fs;
use actix_web::{App, HttpServer};

async fn run_server() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(fs::Files::new("/", "./static").index_file("index.html"))
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}

fn main() -> std::io::Result<()> {
    let system = actix_web::rt::System::new();
    system.block_on(run_server())
}
