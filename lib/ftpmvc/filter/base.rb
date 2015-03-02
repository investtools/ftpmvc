require 'forwardable'

module FTPMVC
  module Filter
    class Base
      extend Forwardable

      def_delegators :@chain, :index, :get, :directory?, :exists?, :put

      attr_reader :options

      def initialize(fs, chain, options={})
        @fs, @chain, @options = fs, chain, options
        setup
      end

      protected

      def setup
        # may be implemented by children
      end
    end
  end
end
