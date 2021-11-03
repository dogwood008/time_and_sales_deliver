#[derive(Queryable)]
pub struct Stock {
    pub code: i32,
    pub datetime: String,
    pub volume: i32,
    pub price: f32,
}