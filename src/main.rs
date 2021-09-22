use actix_web::{get, web, App, HttpServer, Responder};

#[get("/{code}/{datetime}/index.html")]
async fn index(web::Path((code, datetime)): web::Path<(String, String)>) -> impl Responder {
    format!("{{\"code\":\"{}\", \"datetime\":\"{}\"}}", code, datetime)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| App::new().service(index))
        .bind("127.0.0.1:8080")?
        .run()
        .await
}