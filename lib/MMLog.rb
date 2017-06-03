require 'logger'

class MMLog < Logger
  def self.log
    if @logger.nil?
      @logger = Logger.new STDOUT
      @logger.level = ENV['LOG_LEVEL'] || Logger::DEBUG
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
    end
    @logger
  end

  def format_message(severity, timestamp, progname, msg)
    formatted_time = timestamp.strftime("%Y-%m-%d %H:%M:%S.") << timestamp.usec.to_s[0..2].rjust(3)
    "[%s] %s\n" % [formatted_time, msg]
  end
end

# Usage: MMLOG.info(<stuff>)
# (or whatever level of debug info you want to use)
logfile = File.open('log/mm.log','a')
logfile.sync = true
MMLOG = MMLog.new(logfile)
