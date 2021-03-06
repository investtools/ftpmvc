require 'ftpmvc/directory'
require 'ftpmvc/filter/base'

module FTPMVC
  module Filter
    class FilesystemAccess < FTPMVC::Filter::Base
      
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

      def put(path, input)
        @fs.resolve(::File.dirname(path)).put(::File.basename(path), input)
      end
    end
  end
end
