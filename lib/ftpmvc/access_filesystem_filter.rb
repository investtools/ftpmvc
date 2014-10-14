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

    def size(path)
      @fs.resolve(::File.dirname(path)).size(::File.basename(path))
    end

    def directory?(path)
      @fs.directory?(path)
    end
  end
end
