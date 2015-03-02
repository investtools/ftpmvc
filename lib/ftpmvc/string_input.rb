module FTPMVC
  class StringInput

    include Input
    
    def initialize(s)
      @s = s
    end

    def read
      yield @s
    end
  end
end
