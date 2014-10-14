module FTPMVC
  class Filter
    extend Forwardable

    def_delegators :@chain, :index, :size, :get, :directory?

    def initialize(fs, chain)
      @fs, @chain = fs, chain
    end
  end
end
