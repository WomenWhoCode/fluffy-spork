require './config/environment'
require 'pg'
require './config/active_record'
require 'yaml'
require 'http'
require 'erb'
require 'bugsnag'

require './config/i18n'

Dir[File.dirname(__FILE__) + "/../app/models/concerns/*.rb"].each { |file| require file }
Dir[File.dirname(__FILE__) + "/../app/**/*.rb"].each { |file| require file }
Dir[File.dirname(__FILE__) + "/../lib/**/*.rb"].each { |file| require file }

# Load development credentials from config file:
# Copy config/application.yml.example to config/application.yml and fill in the
# correct credentials
config_path = File.expand_path('config/application.yml')
if File.exists? config_path
  ENV.update YAML.load_file(config_path)[ENV["DB"]]
end

# Set up database connection
if ENV["DB"] == "production"
  connection_details = ENV["DATABASE_URL"]
else
  connection_details = YAML::load(ERB.new(IO.read('config/database.yml')).result)[ENV["DB"]]
end
ActiveRecord::Base.establish_connection(connection_details)

# Bugsnag configuration
# https://docs.bugsnag.com/platforms/ruby/other/
Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_KEY']
  config.release_stage = ENV['DB']
end

at_exit do
  if $!
    Bugsnag.notify($!)
  end
end
