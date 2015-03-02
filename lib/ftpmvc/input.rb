module FTPMVC
  module Input
    def read_all
      ''.tap do |content|
        read { |chunk| content << chunk }
      end
    end
  end
end
