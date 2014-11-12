require 'active_support/concern'

module FTPMVC

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= create_logger
  end

  module Logger

    extend ActiveSupport::Concern

    def logger
      FTPMVC.logger
    end

    module ClassMethods
      def logger
        FTPMVC.logger
      end
    end
  end

  protected

  def self.create_logger
    ::Logger.new(STDERR).tap do |logger|
      logger.level = ::Logger::INFO
    end
  end
end
