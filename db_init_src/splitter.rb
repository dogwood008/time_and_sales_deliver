# JPXの「現物情報 歩み値（ティック）」を銘柄コード別にバラすスクリプト。
# http://db-ec.jpx.co.jp/category/C220/C22001202111.html
# Usage: ruby splitter.rb

require 'fileutils'

input_file_path = 'stock_tick_202111.csv'
output_parent_dir_path = './stock_ticks/202111'
FileUtils.mkdir_p(output_parent_dir_path)

def output_file_path(stock_code, output_parent_dir_path)
  "#{output_parent_dir_path}/#{stock_code}.csv"
end

def get_stock_code(row)
  first_index_of_stock_code = 13
  stock_code_size = 4
  row[first_index_of_stock_code..first_index_of_stock_code + stock_code_size - 1]
end

current_stock_code = nil
file_pointer = nil
headers = nil
puts 'START'
puts "input_file_path: #{input_file_path}"
File.foreach(input_file_path).with_index do |row, i|
  headers = row and next if i == 0
  stock_code = get_stock_code(row)
  if stock_code != current_stock_code
    puts "[#{current_stock_code = stock_code}]"
    file_pointer&.close
    output_file_path = output_file_path(stock_code, output_parent_dir_path)
    file_pointer = File.open(output_file_path, 'w')
    file_pointer.puts headers
  end
  file_pointer.puts row
  puts(sprintf("[#{stock_code}] Lines: %9d", i)) if i % 10000 == 0
end
file_pointer.close
puts 'END'