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
  property :note, Text
  property :created_at, DateTime
end

DataMapper.finalize

# automatically create the sources table
DataMapper.auto_upgrade!

# set haml options
configure do
  set :haml, :format => :html5
end

get '/' do
  order = 'created_at'
  if params[:sort]
    order = ['title', 'author', 'url', 'note', 'created_at'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end
  puts "HERE IT IS: #{order}"
  @sources = Source.all :order => [ (order.eql?('created_at') ? order.to_sym.desc : order.to_sym.asc) ]

  haml :index
end

post '/new' do
  # create makes the resource immediately
  @source = Source.create :title => params[:title], :author => params[:author], :url => params[:url], :note => params[:note], :created_at => Time.now

  redirect '/'
end

# delete a resource
get "/:id/delete" do|id|
  s = Source.get(id)
  s.destroy
  redirect '/'
end

# use scss
get '/stylesheets/:sheet.css' do
  scss :"#{params[:sheet]}"
end

not_found do
  redirect '/'
end
