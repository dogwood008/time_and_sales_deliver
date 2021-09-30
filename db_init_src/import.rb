require 'pg'
require './sbi'

DB_HOST = ENV.fetch('DB_HOST', 'db')
DB_PORT = ENV.fetch('DB_PORT', 5432)
DB_USER = ENV.fetch('DB_USER', 'postgres')
DB_PW = ENV.fetch('DB_PW', 'postgres')

# https://deveiate.org/code/pg/PG/Connection.html#method-c-new
conn = PG.connect(
  host: DB_HOST,
  port: DB_PORT,
  user: DB_USER,
  password: DB_PW,
)

stock_code = 7974
date = '2021-09-09'
file_path = "./#{stock_code}_#{date}.csv"

enc = PG::TextEncoder::CopyRow.new

conn.exec(%{CREATE TABLE IF NOT EXISTS stock_#{stock_code} (
  datetime timestamp NOT NULL,
  volume int NOT NULL,
  price float NOT NULL
);})

conn.copy_data("COPY stock_#{stock_code} FROM STDIN", enc) do
  Sbi.new(file_path).each_line do |line|
    conn.put_copy_data line
  end
end
