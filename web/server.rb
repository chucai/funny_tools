require 'sinatra'
require "sinatra/json"
require "sinatra/reloader" if development?
require "tire"
require 'json'

require 'pry'

require_relative 'config/config.rb'
dir_name = File.expand_path(File.dirname(__FILE__), "models")
Dir.glob(File.join(dir_name, "*.rb")).each do |file|
  require file
end



get "/" do
  erb :index
end

get "/page/:page" do
  max_page = 672
  @current_page = params[:page].to_i || 1
  @current_page = max_page if @current_page > max_page
  @prev_page = (@current_page - 1) < 1 ? 1 : (@current_page - 1)
  @next_page = (@current_page + 1) > max_page ? max_page : (@current_page + 1)
  @sites = Site.fetch(from: @current_page)
  json @sites.map(&:to_json)
end

get "/search/:name" do
  @sites = Site.search(params[:name])
  json @sites.map(&:to_json)
end

