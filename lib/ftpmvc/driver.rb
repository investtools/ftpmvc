require 'em-ftpd'
require 'ftpmvc/directory'

module FTPMVC
  class Driver
    def initialize(root)
      @root = root
    end

    def dir_contents(path)
      yield @root.resolve(path).index.map { |node| EM::FTPD::DirectoryItem.new(name: node.name) }
    end

    def authenticate(username, password)
      yield true
    end

    def change_dir(path)
      yield @root.directory?(path)
    end

    def get_file(path)
      yield @root.resolve(::File.dirname(path)).get(::File.basename(path))
    end

    def bytes(path)
      yield @root.resolve(::File.dirname(path)).size(::File.basename(path))
    end
  end
end
