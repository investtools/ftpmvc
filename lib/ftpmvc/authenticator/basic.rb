module FTPMVC
  module Authenticator
    class Basic
      def initialize(options={})
        @users = options[:users]
      end

      def authenticate(username, password)
        @users[username] == password
      end
    end
  end
end
