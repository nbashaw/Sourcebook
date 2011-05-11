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
  property :note, String
  property :created_at, DateTime
end

DataMapper.finalize

# automatically create the sources table
DataMapper.auto_upgrade!


# set haml options
configure do
  set :haml, :format => :html5
end

post '/new' do
  # create makes the resource immediately
  @source = Source.create :title => params[:title],
    :author => params[:author],
    :url => params[:url],
    :note => params[:note],
    :created_at => Time.now

  redirect to("/"), 303
end

get '/' do
  @sources = Source.all :order => [ (:"created_at").desc ]
  haml :index
end

# delete a resource
get "/:id/delete" do|id|
  s = Source.get(id)
  
  s.destroy
  redirect to('/'), 303
end

# use scss
get '/:stylesheet.css' do
  scss :"#{params[:stylesheet]}"
end

not_found do
  redirect '/'
end