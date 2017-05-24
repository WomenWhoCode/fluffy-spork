require "rubygems"
require "bundler/setup"

require 'pg'
require 'active_record'
require 'yaml'
require 'http'

require './config/environment'
Dir.glob('lib/tasks/*.rake').each { |r| load r}

namespace :db do

  desc "Migrate database"
  task :migrate do
    connection_details = YAML::load(File.open('config/database.yml'))[ENV["DATABASE_ENV"]]

    puts connection_details
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::Migrator.migrate("db/migrate/")
  end

  desc "Create database"
  task :create do
    connection_details = YAML::load(File.open('config/database.yml'))[ENV["DATABASE_ENV"]]

    # Must use postgres as database name when establishing connection
    # https://github.com/rails/rails/issues/6188#issuecomment-5548524
    admin_connection = connection_details.merge(
      'database'=> 'postgres',
      'schema_search_path'=> 'public',
    )
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(connection_details.fetch('database'))
  end

  desc "Drop database"
  task :drop do
    connection_details = YAML::load(File.open('config/database.yml'))[ENV["DATABASE_ENV"]]
    admin_connection = connection_details.merge(
      'database'=> 'postgres',
      'schema_search_path'=> 'public',
    )
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.drop_database(connection_details.fetch('database'))
  end
end
