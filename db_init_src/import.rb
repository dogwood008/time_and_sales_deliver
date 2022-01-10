require 'pg'
# require './sbi'
require './jpx'

DB_HOST = ENV.fetch('POSTGRES_HOST')
DB_PORT = ENV.fetch('POSTGRES_PORT', 5432)
DB_USER = ENV.fetch('POSTGRES_USER')
DB_PW = ENV.fetch('POSTGRES_PASSWORD')
DB_NAME = ENV.fetch('POSTGRES_DB_NAME')

# https://deveiate.org/code/pg/PG/Connection.html#method-c-new
conn = PG.connect(
  host: DB_HOST,
  port: DB_PORT,
  user: DB_USER,
  password: DB_PW,
)

stock_code = 7974
#date = '2021-09-09'
#file_path = "./#{stock_code}_#{date}.csv"
file_path = "./stock_ticks/202111/#{stock_code}.csv"

enc = PG::TextEncoder::CopyRow.new

conn.exec(%{SELECT 'CREATE DATABASE #{DB_NAME}'
  WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '#{DB_NAME}')})

conn.exec(%{CREATE TABLE IF NOT EXISTS stock_#{stock_code} (
  datetime timestamp NOT NULL,
  volume int NOT NULL,
  price float NOT NULL
);})

conn.copy_data("COPY stock_#{stock_code} FROM STDIN", enc) do
  Jpx.new(file_path).each_line do |line|
    conn.put_copy_data line
  end
  # SBI
  # Sbi.new(file_path).each_line do |line|
  #   conn.put_copy_data line
  # end
end

puts 'Import completed.'