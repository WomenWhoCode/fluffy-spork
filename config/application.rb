require './config/environment'
Dir.glob('app/models/*.rb').each { |r| load r}
Dir.glob('lib/tasks/*.rake').each { |r| load r}

# Load development credentials from config file:
# Copy config/application.yml.example to config/application.yml and fill in the
# correct credentials
config_path = File.expand_path('config/application.yml')
if File.exists? config_path
  ENV.update YAML.load_file(config_path)[ENV["DATABASE_ENV"]]
end

# Set up database connection
connection_details = YAML::load(File.open('config/database.yml'))[ENV["DATABASE_ENV"]]
ActiveRecord::Base.establish_connection(connection_details)
