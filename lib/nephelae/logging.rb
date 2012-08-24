require 'logger'
module Nephelae
  module Logging
    def log
      Logging.logger
    end

    def self.logger
      @logger || Logger.new(STDOUT)
    end

    def self.logger=(logger)
      @logger = logger
    end
  end
end
