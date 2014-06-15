require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require(:default, ENV['RACK_ENV'].to_sym) unless ENV['RACK_ENV'].nil?

require 'logger'
require 'json'
require 'digest/sha2'

SINATRA_ROOT = File.join(File.dirname(__FILE__), '..')
autoload_paths = %w(config/initializers lib)
autoload_paths.each do |path|
  file_path = File.join(SINATRA_ROOT, path)
  $LOAD_PATH.unshift(file_path)
  Dir["#{file_path}/**/*.rb"].each {|f| require f }
end
require File.join(SINATRA_ROOT, 'app')
