require 'sinatra'
#require 'json'
require 'rack/post-body-to-params'
require 'sequel'
require 'active_support'

ActiveSupport::JSON.backend = 'Yajl'

DB = Sequel.sqlite

# create an items table
DB.create_table :projects do
  primary_key :id
  String :name
  String :description
  String :site
end

use Rack::PostBodyToParams

set :public_folder, File.dirname(__FILE__) + '/public'

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/projects' do
  begin
    results = DB[:projects].all
    logger.info results.inspect
    results.to_json
  rescue
    "[]"
  end
end

post '/projects' do
  puts params.inspect
  data = { name: params[:name], description: params[:description], site: params[:site] }
  record = DB[:projects].insert(data)
  data.to_json
end

get '/projects/:id' do |id|
  DB[:projects].where(id: id).first.to_json
end

put '/projects/:id' do |id|
  puts params.inspect
  data = DB[:projects].where(id: id.to_i).first
  data.update(name: params[:name], description: params[:description], site: params[:site])
  '{}'
end
