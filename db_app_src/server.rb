require 'sinatra'
require 'json'
require './app'

set :bind, '0.0.0.0'

app = App.new

# e.g.) /7974/2021-09-09T14:59:30
get '/:code/:datetime' do
  stock_code = params['code']
  datetime = params['datetime']
  app.single(stock_code, datetime).to_json
end

# e.g.) /7974/2021-09-09T14:59:30/2021-09-10T14:59:30
get '/:code/:from_dt/:to_dt' do
  stock_code = params['code']
  from_dt = params['from_dt']
  to_dt = params['to_dt']
  app.range(stock_code, from_dt, to_dt).to_json
end

get '/exit' do
  app.close
end