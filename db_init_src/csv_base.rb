require 'csv'

class CsvBase
  def initialize(file_path)
    @file_path = file_path
  end

  def each_line
    open(@file_path, 'r') do |f|
      CSV.foreach(@file_path,
          headers: header?, encoding: encoding) do |row|
        yield(parse(row))
      end
    end
  end

  def parse(row)
    raise NotImplementedError
  end

  # @params [CSV::Row] row
  def datetime(row)
    raise NotImplementedError
  end

  # @params [CSV::Row] row
  def volume(row)
    raise NotImplementedError
  end

  # @params [CSV::Row] row
  def price(row)
    raise NotImplementedError
  end

  private

  def header?
    raise NotImplementedError
  end

  def encoding
    'utf-8'
  end
end