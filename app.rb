require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require_relative './config/environments'

class Item < ActiveRecord::Base
	validates_presence_of :title

	has_many :comments
end 

class Comment < ActiveRecord::Base
	belongs_to :post
end

get '/' do
	@items = Item.all
	erb :index
end

get '/items/new' do
	erb :item_new
end 

get '/items/:id' do
	@item = Item.find(params[:id])
	@comments = @item.comments
	erb :item_show
end

post '/items/new' do
	@title = params[:title]
	@description = params[:description]
	@item = Item.new(title: @title, description: @description)
	if @item.save
		redirect "/items/#{@item.id}"
	else
		render '/items/new'
	end 
end

get '/items/:id/update' do
	@item = Item.find(params[:id])
	erb :item_update
end 

put '/items/:id/update' do
	@item = Item.find(params[:id])
	@title = params[:title]
	@description = params[:description]
	@is_done = params[:status] == "checked"
	if @item.update_attributes(title: @title, description: @description, is_done: @is_done)
		redirect "/items/#{@item.id}"
	else
		redirect "/items/#{item.id}/update"	
	end 
end

delete '/items/:id/delete' do
	@item = Item.find(params[:id])
	if @item.destroy
		redirect "/"
	else 
		render "/items/#{@item.id}"
	end
end

post '/comments/new' do
	@body = params[:body]
	@item_id = params[:item_id]
	@comment = Comment.new(body: @body, item_id: @item_id)
	if @comment.save
		redirect "/items/#{@item_id}"
	else 
		render "/items/#{@item_id}"
	end 
end 

after do
	ActiveRecord::Base.connection.close
end