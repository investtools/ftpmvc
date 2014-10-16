require 'forwardable'

module FTPMVC
  class Filter
    extend Forwardable

    def_delegators :@chain, :index, :size, :get, :directory?

    def initialize(fs, chain, options={})
      @fs, @chain, @options = fs, chain, options
    end
  end
end
