require 'active_record'
logfile = File.open('log/active_record.log','a')
logfile.sync = true
ActiveRecord::Base.logger = Logger.new(logfile)  

