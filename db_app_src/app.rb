require 'pg'
require 'json'

class App
  DB_HOST = ENV.fetch('POSTGRES_HOST')
  DB_PORT = ENV.fetch('POSTGRES_PORT', 5432)
  DB_USER = ENV.fetch('POSTGRES_USER')
  DB_PW = ENV.fetch('POSTGRES_PASSWORD')
  DB_NAME = ENV.fetch('POSTGRES_DB_NAME')

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

  def exec(stock_code, datetime)
    tick_sql = sql(stock_code, datetime)
    @conn.exec(tick_sql) do |result|
      result.first
    end
  end

  def close
    @conn.finish
  end
end
