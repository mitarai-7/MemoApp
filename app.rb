# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

set :public_folder, 'public'

get '/' do
  'hello'
end

get '/list' do
  datastore = 'data/memo.json'
  @memo_list = File.open(datastore, 'r') { |io| JSON.parse(io.read) } if File.readable?(datastore)
  erb :list
end

get '/new' do
  erb :edit
end

post '/new' do
  # title = params[:title]
  # text = params[:text]

  datastore = 'data/memo.json'
  if File.writable?(datastore)
    memo_list = File.open(datastore, 'r') { |io| JSON.parse(io.read) }
    # params[:id] = 
    memo_list.push(params)
    File.open(datastore, 'w') { |io| io.print JSON.generate(memo_list) }
  end
  erb :edit
end

get '/memo/:id' do
  datastore = 'data/memo.json'
  if File.readable?(datastore)
    memo_list = File.open(datastore, 'r') { |io| JSON.parse(io.read) }
    memo = memo_list.find { |x| x['id'] == params[:id] }
    @title = memo['title']
    @text = memo['text']
  end
  erb :detail
end

patch '/memo/:id' do |id|

end
