# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/memo_repository'

mr = MemoRepository.new

not_found do
  erb :not_found
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memo_list = mr.read
  erb :list
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  mr.create(params['memo_title'], params['memo_text'])
  redirect to('/memos')
end

get '/memos/:id' do
  memo = mr.read(params[:id]).first
  @id = memo[:id]
  @title = memo[:memo_title]
  @text = memo[:memo_text].gsub(/\n/, '<br>')
  erb :detail
end

delete '/memos/:id' do
  mr.delete(params[:id])
  redirect to('/memos')
end

get '/memos/:id/edit' do
  memo = mr.read(params[:id]).first
  @id = memo[:id]
  @title = memo[:memo_title]
  @text = memo[:memo_text].gsub(/\n/, '<br>')
  erb :edit
end

patch '/memos/:id' do
  mr.update(params['id'], params['memo_title'], params['memo_text'])
  redirect to('/memos')
end
