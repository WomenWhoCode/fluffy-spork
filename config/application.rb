require 'pg'
require 'active_record'
require 'yaml'
require 'http'
require 'erb'
require 'bugsnag'

require './config/environment'
require './config/i18n'

Dir.glob('app/models/**/*.rb').each { |r| load r}
Dir.glob('lib/**/*.rb').each { |r| load r}

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
