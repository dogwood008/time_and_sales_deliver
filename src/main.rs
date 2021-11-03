extern crate time_and_sales_deliver;
extern crate diesel;

use self::models::*;
use self::time_and_sales_deliver::*;
use self::diesel::prelude::*;

use std::{sync::mpsc, thread};

use futures::executor;

use actix_web::{get, middleware, web, App, Responder, HttpResponse, HttpServer};

use self::time_and_sales_deliver::establish_connection;
use self::time_and_sales_deliver::models::Stock;
use self::time_and_sales_deliver::schema::stocks::dsl::*;

//use self::diesel::prelude::*;

#[get("/test/{code}/{datetime}")]
async fn test(web::Path((given_code, given_datetime)): web::Path<(String, String)>) -> HttpResponse {
    // let sql = format!("ORDER BY abs(TIMESTAMPDIFF(second, datetime, \"{}\")) LIMIT 1", datetime);
    // println!("{}", sql);
    //use self::time_and_sales_deliver::models::Stock;
    //use self::models::*;
    //use self::diesel::prelude::*;
    let connection = establish_connection();
    let results = stocks.filter(code.eq(given_code as time_and_sales_deliver::schema::stocks::code))
        .limit(5)
        .load::<Stock>(&connection)
        .expect("Error loading stocks");
    HttpResponse::NoContent().finish()
}

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
            .service(test)
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