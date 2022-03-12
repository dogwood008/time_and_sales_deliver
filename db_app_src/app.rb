require 'pg'
require 'json'
require 'time'

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

  def single_sql(stock_code, datetime)
    %{SELECT *
      FROM stock_#{stock_code}
      WHERE datetime <= '#{datetime}'
      ORDER BY datetime ASC
      LIMIT 1;}
  end

  # ORDER BY datetime DESC があるので、from & toは逆に配置
  def range_sql(stock_code, from_dt, to_dt)
    %{SELECT datetime, volume::float, price::float
      FROM stock_#{stock_code}
      WHERE datetime <= '#{to_dt}'
      AND '#{from_dt}' <= datetime
      ORDER BY datetime ASC;}
  end

  def single(stock_code, datetime)
    tick_sql = single_sql(stock_code, datetime)
    @conn.exec(tick_sql) do |result|
      result.first
    end
  end

  def range(stock_code, from_dt, to_dt)
    tick_sql = range_sql(stock_code, from_dt, to_dt)
    resp = @conn.exec(tick_sql) { |result|
      result.values
    }
    resp.map{|r| [Time.parse("#{r[0]}+09:00"), r[1], r[2]] }
  end

  def close
    @conn.finish
  end
end
