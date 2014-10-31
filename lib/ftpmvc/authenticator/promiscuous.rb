module FTPMVC
  module Authenticator
    class Promiscuous
      def authenticate(username, password)
        true
      end
    end
  end
end
