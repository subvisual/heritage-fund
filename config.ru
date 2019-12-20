# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# run Rails.application

map '/3-10k/' do
  run Rails.application
end
