use std::{sync::mpsc, thread};

use futures::executor;

use actix_web::{get, middleware, web, App, Responder, HttpResponse, HttpServer};

//async fn read(datetime: &str) {
//    let sql = format!("ORDER BY abs(TIMESTAMPDIFF(second, datetime, "{}")) LIMIT 1", datetime);
//    println!(sql)
//}

#[get("/{code}/{datetime}/index.html")]
async fn index(web::Path((code, datetime)): web::Path<(String, String)>) -> impl Responder {
    //read(datetime.as_str());
    format!("{{\"code\":\"{}\", \"datetime\":\"{}\"}}", code, datetime)
}

// https://github.com/actix/examples/pull/240/files
#[get("/stop")]
async fn stop(stopper: web::Data<mpsc::Sender<()>>) -> HttpResponse {
    // make request that sends message through the Sender
    stopper.send(()).unwrap();

    HttpResponse::NoContent().finish()
}

#[get("/hello")]
async fn hello() -> &'static str {
    "Hello world!"
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    std::env::set_var("RUST_LOG", "actix_server=debug,actix_web=debug");
    env_logger::init();

    // create a channel
    let (tx, rx) = mpsc::channel::<()>();

    let bind = "0.0.0.0:8080";

    // start server as normal but don't .await after .run() yet
    let server = HttpServer::new(move || {
        // give the server a Sender in .data
        let stopper = tx.clone();

        App::new()
            .data(stopper)
            .wrap(middleware::Logger::default())
            .service(hello)
            .service(index)
            .service(stop)
    })
    .bind(&bind)?
    .run();

    // clone the Server handle
    let srv = server.clone();
    thread::spawn(move || {
        // wait for shutdown signal
        rx.recv().unwrap();

        // stop server gracefully
        executor::block_on(srv.stop(true))
    });

    // run server
    server.await
}