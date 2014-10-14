module FTPMVC
  class Filter
    def initialize(fs, chain)
      @fs, @chain = fs, chain
    end

    def index(path)
      @chain.index(path)
    end
  end
end
