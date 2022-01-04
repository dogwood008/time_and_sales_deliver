require 'sinatra'
require 'json'
require './app'

set :bind, '0.0.0.0'

app = App.new

get '/:code/:datetime' do
  app.exec(7974, '2021-09-09 14:59:30').to_json
end

get '/exit' do
  app.close
end