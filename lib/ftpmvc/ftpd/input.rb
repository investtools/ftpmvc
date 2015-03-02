require 'ftpmvc/input'

module FTPMVC
  module Ftpd
    class Input
      
      include FTPMVC::Input

      def initialize(stream)
        @stream = stream
      end

      def read
        while chunk = @stream.read
          yield chunk
        end
      end
    end
  end
end
