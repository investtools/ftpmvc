require 'forwardable'

module FTPMVC
  module Filter
    class Base
      extend Forwardable

      def_delegators :@chain, :index, :get, :directory?, :exists?, :put

      def initialize(fs, chain, options={})
        @fs, @chain, @options = fs, chain, options
      end
    end
  end
end
