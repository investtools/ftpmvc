require 'ftpmvc/ftpd/file_system'

module FTPMVC
  module Ftpd
    class Driver
      def initialize(application)
        @application = application
      end

      def authenticate(username, password)
        @application.authenticate(username, password)
      end

      def file_system(username)
        FileSystem.new(@application)
      end

    end
  end
end
