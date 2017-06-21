require 'active_record'
if ENV["DB"] != "production"
  logfile = File.open('log/active_record.log','a')
  logfile.sync = true
  ActiveRecord::Base.logger = Logger.new(logfile)
end
