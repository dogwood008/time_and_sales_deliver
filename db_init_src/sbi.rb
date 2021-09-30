require './csv_base'
require 'time'

class Sbi < CsvBase
  def header?
    true
  end
  
  def encoding
    'sjis:utf-8'
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
    Time.strptime(row['日付'], '%Y%m%d').strftime('%Y-%m-%d')
  end

  # @params [CSV::Row] row
  def time(row)
    Time.strptime(row['時間'], '%H%M').strftime('%H:%M:00+0900')
  end

  def volume(row)
    row['出来高'].to_i
  end

  def price(row)
    row['約定値'].to_i
  end
end