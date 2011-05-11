class Sourcebook < Sinatra::Base
  configure do
    disable :run
    set :views, File.join(File.dirname(__FILE__), 'views')
    set :public, File.join(File.dirname(__FILE__), 'public')

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
    scss_options = {:syntax => :scss}
    if ENV['RACK_ENV'].eql? 'production'
      scss_options.merge!({:style => :compressed})
    end

    scss :"#{params[:sheet]}", scss_options
  end

  not_found do
    redirect '/'
  end

end
