# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'sinatra/reloader'

DATASTORE = 'data/memo.json'

not_found do
  erb :not_found
end

get '/' do
  redirect to('/list')
end

get '/list' do
  @memo_list = File.open(DATASTORE, 'r') { |io| JSON.parse(io.read) } if File.readable?(DATASTORE)
  erb :list
end

get '/new' do
  erb :new
end

post '/new' do
  if File.writable?(datastore)
    memo_list = File.open(datastore, 'r') { |io| JSON.parse(io.read) }
    if memo_list.empty?
      params[:id] = '1'
    else
      index = memo_list.size - 1
      params[:id] = ((memo_list[index])['id'].to_i + 1).to_s
    end
    memo_list.push(params)
    File.open(DATASTORE, 'w') { |io| io.print JSON.generate(memo_list) }
  end
  redirect to('/list')
end

get '/memo/:id' do
  if File.readable?(DATASTORE)
    memo_list = File.open(DATASTORE, 'r') { |io| JSON.parse(io.read) }
    memo = memo_list.find { |x| x['id'] == params[:id] }
    @id = memo['id']
    @title = memo['memo_title']
    @text = memo['memo_text'].gsub(/\n/, '<br>')
  end
  erb :detail
end

delete '/memo/:id' do
  if File.writable?(DATASTORE)
    memo_list = File.open(DATASTORE, 'r') { |io| JSON.parse(io.read) }
    memo_list.delete_if { |x| x['id'] == params[:id] }
    File.open(DATASTORE, 'w') { |io| io.print JSON.generate(memo_list) }
  end
  200
end

get '/edit/:id' do
  if File.readable?(DATASTORE)
    memo_list = File.open(DATASTORE, 'r') { |io| JSON.parse(io.read) }
    memo = memo_list.find { |x| x['id'] == params[:id] }
    @id = memo['id']
    @title = memo['memo_title']
    @text = memo['memo_text']
  end
  erb :edit
end

patch '/edit/:id' do
  if File.writable?(DATASTORE)
    memo_list = File.open(DATASTORE, 'r') { |io| JSON.parse(io.read) }
    index = memo_list.find_index { |x| x['id'] == params[:id] }
    (memo_list[index])['memo_title'] = params[:title]
    (memo_list[index])['memo_text'] = params[:text]
    File.open(DATASTORE, 'w') { |io| io.print JSON.generate(memo_list) }
  end
  200
end
