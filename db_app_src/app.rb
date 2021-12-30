require 'pg'

DB_HOST = ENV.fetch('POSTGRES_HOST')
DB_PORT = ENV.fetch('POSTGRES_PORT', 5432)
DB_USER = ENV.fetch('POSTGRES_USER')
DB_PW = ENV.fetch('POSTGRES_PASSWORD')
DB_NAME = ENV.fetch('POSTGRES_DB_NAME')
conn = PG.connect(
  host: DB_HOST,
  port: DB_PORT,
  user: DB_USER,
  password: DB_PW,
  dbname: DB_NAME,
)

begin
ensure
  conn.finish
end