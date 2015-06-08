require "pry"
require "pg"
require "sinatra"
require "sinatra/contrib"
require "redcarpet"

require_relative "app"

use Rack::MethodOverride

run App::Server