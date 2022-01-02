require 'pg'
require 'json'

class App
  DB_HOST = ENV.fetch('POSTGRES_HOST')
  DB_PORT = ENV.fetch('POSTGRES_PORT', 5432)
  DB_USER = ENV.fetch('POSTGRES_USER')
  DB_PW = ENV.fetch('POSTGRES_PASSWORD')
  DB_NAME = ENV.fetch('POSTGRES_DB_NAME')

  STOCK_CODE = 7974
  DATETIME = '2021-09-09 14:59:30'

  APP_ENV = ENV.fetch('APP_ENV', 'dev')
  def development?
    APP_ENV == 'dev'
  end

  def initialize
    @conn = PG.connect(
      host: DB_HOST,
      port: DB_PORT,
      user: DB_USER,
      password: DB_PW,
    )

    require 'debug' if development?
  end

  def sql(stock_code, datetime)
    %{SELECT *
      FROM stock_#{stock_code}
      WHERE datetime <= '#{datetime}'
      ORDER BY datetime DESC
      LIMIT 1;}
  end

  def exec
    tick_sql = sql(STOCK_CODE, DATETIME)
    @conn.exec(tick_sql) do |result|
      result.first
    end
  ensure
    @conn.finish
  end
end

puts App.new.exec.to_json