require 'active_record'
if ENV["DB"] == "production"
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
