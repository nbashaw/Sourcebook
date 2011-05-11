# Default our Rack environment
ENV['RACK_ENV'] = 'development' if ENV['RACK_ENV'].nil?

# Tell Bundler to require all our gems
require 'bundler/setup'
Bundler.require :default, :"#{ENV['RACK_ENV']}"

# Models
require './db/schema.rb'

# Rack configuration
configure do
  datamapper_config = YAML.load File.new('./config/database.yml')
  DataMapper.setup :default, datamapper_config[ENV['RACK_ENV']] 
end
