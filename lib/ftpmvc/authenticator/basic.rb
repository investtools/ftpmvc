module FTPMVC
  module Authenticator
    class Basic < Struct.new(:users)
      def initialize(options={})
        super options[:users]
      end

      def authenticate(username, password)
        users[username] == password
      end
    end
  end
end
