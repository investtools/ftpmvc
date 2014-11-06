module FTPMVC
  module Ftpd
    class FileSystem
      def initialize(application)
        @application = application
      end

      def dir(path)
        @application.index(path[/^[^*]*/]).map { |node| ::File.join(path, node.name) }
      end

      def directory?(path)
        @application.directory?(path)
      end

      def read(path)
        yield @application.get(path)
      end

      def accessible?(path)
        true
      end

      def exists?(path)
        @application.exists?(path)
      end

      def file_info(path)
        ::Ftpd::FileInfo.new(
          :ftype => directory?(path) ? 'directory' : 'file',
          :group => 'nogroup',
          :mode => 0777,
          :mtime => Time.now,
          :nlink => 33,
          :owner => 'nobody',
          :path => path,
          :size => 0)
      end
    end
  end
end
