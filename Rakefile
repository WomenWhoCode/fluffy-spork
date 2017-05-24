require "rubygems"
require "bundler/setup"

Dir.glob('lib/tasks/*.rake').each { |r| load r}

require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

require './config/application'
