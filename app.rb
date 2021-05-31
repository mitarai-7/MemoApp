# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'sinatra/reloader'

not_found do
  erb :not_found
end

get '/' do
  redirect to('/memo/list')
end

get '/memo/list' do
  @memo_list = File.open(DATASTORE, 'r') { |io| JSON.parse(io.read) } if File.readable?(DATASTORE)
  erb :list
end

get '/memo/new' do
  erb :new
end

post '/memo/new' do
  memo = { memo_title: params['memo_title'], memo_text: params['memo_text'] }
  if File.writable?(DATASTORE)
    memo_list = File.open(DATASTORE, 'r') { |io| JSON.parse(io.read) }
    if memo_list.empty?
      memo[:id] = '1'
    else
      index = memo_list.size - 1
      memo[:id] = ((memo_list[index])['id'].to_i + 1).to_s
    end
    memo_list.push(memo)
    File.open(DATASTORE, 'w') { |io| io.print JSON.generate(memo_list) }
  end
  redirect to('/memo/list')
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
  redirect to('/memo/list')
end

get '/memo/edit/:id' do
  if File.readable?(DATASTORE)
    memo_list = File.open(DATASTORE, 'r') { |io| JSON.parse(io.read) }
    memo = memo_list.find { |x| x['id'] == params[:id] }
    @id = memo['id']
    @title = memo['memo_title']
    @text = memo['memo_text']
  end
  erb :edit
end

patch '/memo/edit/:id' do
  if File.writable?(DATASTORE)
    memo_list = File.open(DATASTORE, 'r') { |io| JSON.parse(io.read) }
    index = memo_list.find_index { |x| x['id'] == params[:id] }
    (memo_list[index])['memo_title'] = params['memo_title']
    (memo_list[index])['memo_text'] = params['memo_text']
    File.open(DATASTORE, 'w') { |io| io.print JSON.generate(memo_list) }
  end
  redirect to('/memo/list')
end
