require 'sinatra'
require 'json'
require './app'

set :bind, '0.0.0.0'

app = App.new

# e.g.) /7974/2021-09-09T14:59:30
get '/:code/:datetime' do
  stock_code = params['code']
  datetime = params['datetime']
  app.exec(stock_code, datetime).to_json
end

get '/exit' do
  app.close
end