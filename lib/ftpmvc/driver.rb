require 'em-ftpd'
require 'ftpmvc/directory'

module FTPMVC
  class Driver
    def initialize(application)
      @application = application
    end

    def dir_contents(path)
      yield @application.index(path).map { |node| EM::FTPD::DirectoryItem.new(name: node.name) }
    end

    def authenticate(username, password)
      yield true
    end

    def change_dir(path)
      yield @application.directory?(path)
    end

    def get_file(path)
      yield @application.get(path)
    end

    def bytes(path)
      yield @application.size(path)
    end
  end
end
