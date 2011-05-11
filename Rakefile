namespace :db do
  require './config/environment.rb'

  task :upgrade do
    DataMapper.auto_upgrade!
  end

  task :migrate do
    DataMapper.auto_migrate!
  end
end
