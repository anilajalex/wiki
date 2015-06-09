require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'] || 'development')

require_relative './app'

use Rack::MethodOverride

run App::Server