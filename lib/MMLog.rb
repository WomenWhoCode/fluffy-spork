require 'logger'

class MMLog
  def self.log
    if @logger.nil?
      @logger = Logger.new STDOUT
      @logger.level = ENV['LOG_LEVEL'] || Logger::DEBUG
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
    end
    @logger
  end
end