table! {
    stocks (code, datetime) {
        code -> Int4,
        datetime -> Timestamp,
        volume -> Int4,
        price -> Numeric,
    }
}
