require 'csv'

class CsvBase
  def initialize(file_path)
    @file_path = file_path
  end

  # each_line前に実施することがあればオーバライドして記載する
  def preprocess(file_path)
    pass
  end

  # each_line後に実施することがあればオーバライドして記載する
  def postprocess(file_path)
    pass
  end

  def each_line
    file_path = preprocess(@file_path) || @file_path
    CSV.foreach(file_path,
        headers: header?, encoding: encoding) do |row|
      yield(parse(row))
    end
    postprocess(file_path)
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

  protected

  # 前場
  # @returns [Array<Array<Integer, Integer>>] [[9, 0], ..., [11, 30]]
  def zenba_time
    @zenba_time ||= [*(9..10).to_a.product((0..59).to_a), *[11].product((0..30).to_a)].freeze
  end

  # 後場
  # @returns [Array<Array<Integer, Integer>>] [[12, 30], ..., [15, 0]]
  def goba_time
    @goba_time ||= [*[12].product((30..59).to_a), *(13..14).to_a.product((0..59).to_a), [15, 0]].freeze
  end

  # ザラ場
  # @returns [Array<Array<Integer, Integer>>] [[9, 0], ..., [15, 0]]
  def zaraba_time
    @zaraba_time ||= [*zenba_time, *goba_time].freeze
  end

  private

  def header?
    raise NotImplementedError
  end

  def encoding
    'utf-8'
  end
end