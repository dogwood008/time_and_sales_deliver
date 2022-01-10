require './csv_base'
require 'time'
require 'tempfile'

class Jpx < CsvBase
  def header?
    true
  end

  def encoding
    'utf-8'
  end

  def parse(row)
    [datetime(row), volume(row), price(row)]
  end

  # @params [CSV::Row] row
  def datetime(row)
    "#{date(row)}T#{time(row)}"
  end

  private

  # @params [CSV::Row] row
  def date(row)
    Time.strptime(row['date'], '%Y%m%d').strftime('%Y-%m-%d')
  end

  # @params [CSV::Row] row
  def time(row)
    Time.strptime(row['time'], '%H%M%S%N').strftime('%H:%M:%S.%6N+0900')  # ナノ秒は6桁
  end

  def volume(row)
    row['trading volume'].to_i
  end

  def price(row)
    row['price'].to_i
  end
end