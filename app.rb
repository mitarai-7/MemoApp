# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

set :public_folder, 'public'

get '/list' do
  datastore = 'data/memo.json'
  @memo_list = File.open(datastore, 'r') { |io| JSON.parse(io.read) } if File.readable?(datastore)
  erb :list
end

get '/new' do
  erb :new
end

post '/new' do
  datastore = 'data/memo.json'
  if File.writable?(datastore)
    memo_list = File.open(datastore, 'r') { |io| JSON.parse(io.read) }
    index = memo_list.size - 1
    params[:id] = ((memo_list[index])['id'].to_i + 1).to_s
    memo_list.push(params)
    File.open(datastore, 'w') { |io| io.print JSON.generate(memo_list) }
  end
  redirect to('/list')
end

get '/memo/:id' do
  datastore = 'data/memo.json'
  if File.readable?(datastore)
    memo_list = File.open(datastore, 'r') { |io| JSON.parse(io.read) }
    memo = memo_list.find { |x| x['id'] == params[:id] }
    @id = memo['id']
    @title = memo['title']
    @text = memo['text']
  end
  erb :detail
end

get '/edit/:id' do
  datastore = 'data/memo.json'
  if File.readable?(datastore)
    memo_list = File.open(datastore, 'r') { |io| JSON.parse(io.read) }
    memo = memo_list.find { |x| x['id'] == params[:id] }
    @id = memo['id']
    @title = memo['title']
    @text = memo['text']
  end
  erb :edit
end

patch '/edit/:id' do
  datastore = 'data/memo.json'
  if File.writable?(datastore)
    memo_list = File.open(datastore, 'r') { |io| JSON.parse(io.read) }
    index = memo_list.find_index { |x| x['id'] == params[:id] }
    (memo_list[index])['title'] = params[:title]
    (memo_list[index])['text'] = params[:text]
    File.open(datastore, 'w') { |io| io.print JSON.generate(memo_list) }
  end
  200
end

delete '/memo/:id' do
  datastore = 'data/memo.json'
  if File.writable?(datastore)
    memo_list = File.open(datastore, 'r') { |io| JSON.parse(io.read) }
    memo_list.delete_if { |x| x['id'] == params[:id] }
    File.open(datastore, 'w') { |io| io.print JSON.generate(memo_list) }
  end
  200
end
