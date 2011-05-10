require 'bundler/setup'
Bundler.require :default

# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/srcs.db")

class Source
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :author, String
  property :url, String
  property :created_at, DateTime
end

# automatically create the post table
Source.auto_upgrade!

# set haml options
configure do
  set :haml, :format => :html5
end

get '/' do
  haml :index
end

# use scss
get '/:stylesheet.css' do
  scss :"#{params[:stylesheet]}"
end

not_found do
  redirect '/'
end