require './csv_base'
require 'time'
require 'tempfile'

class Sbi < CsvBase
  def header?
    true
  end
  
  def encoding
    'utf-8'
  end

  def original_encoding
    'sjis:utf-8'
  end

  def preprocess(file_path)
    csv = CSV.read(file_path, encoding: original_encoding).reverse  # SBIのCSV歩み値は、時間降順になっているため

    zaraba_time.each do |pseudo_current_hm_arr|
      pseudo_current_hm = pseudo_current_hm_arr.map { |hm| sprintf('%02d', hm) }.join('')
      time_column_index = 1
      rows_to_updates = csv.find_all { |row| row[time_column_index] == pseudo_current_hm }
      rows_size = rows_to_updates.empty? ? 1 : rows_to_updates.size
      rows_to_updates.each.with_index do |row, i|
        pseudo_seconds = sprintf('%02d', i * 60 / rows_size)
        row[time_column_index] = "#{pseudo_current_hm}#{pseudo_seconds}"  # 秒を按分
      end
    end
    f = Tempfile.open
    CSV.open(f.path, 'wb') do |csv_fw|
      csv.reverse.each do |row|  # 再度降順に戻す
        csv_fw << row
      end
    end
    f
  end

  def postprocess(file_path)
    file_path.close
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
    Time.strptime(row['時間'], '%H%M%S').strftime('%H:%M:%S+0900')
  end

  def volume(row)
    row['出来高'].to_i
  end

  def price(row)
    row['約定値'].to_i
  end
end