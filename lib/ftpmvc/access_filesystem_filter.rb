require 'ftpmvc/directory'
require 'ftpmvc/filter'

module FTPMVC
  class AccessFilesystemFilter < FTPMVC::Filter
    
    def get(path)
      @fs.resolve(::File.dirname(path)).get(::File.basename(path))
    end

    def index(path)
      @fs.resolve(path).index
    end

    def directory?(path)
      @fs.resolve(path).kind_of?(Directory)
    end

    def exists?(path)
      not @fs.resolve(path).nil?
    end
  end
end
