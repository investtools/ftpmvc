require 'ftpmvc/logger'
require 'ftpmvc/ftpd/input'

module FTPMVC
  module Ftpd
    class FileSystem

      include Logger

      def initialize(application)
        @application = application
      end

      def dir(path)
        logger.debug { "FTPMVC::Ftpd::FileSystem#dir(#{path})" }
        @application.index(path.gsub('/*', '')).map { |node| ::File.join(path, node.name) }
      end

      def directory?(path)
        logger.debug { "FTPMVC::Ftpd::FileSystem#directory?(#{path})" }
        @application.directory?(path.gsub('/*', ''))
      end

      def read(path)
        logger.debug { "FTPMVC::Ftpd::FileSystem#read(#{path})" }
        yield @application.get(path)
      end

      def write(path, stream)
        logger.debug { "FTPMVC::Ftpd::FileSystem#write(#{path}, ...)" }
        @application.put(path, Input.new(stream))
      end

      def accessible?(path)
        logger.debug { "FTPMVC::Ftpd::FileSystem#accessible?(#{path})" }
        true
      end

      def exists?(path)
        logger.debug { "FTPMVC::Ftpd::FileSystem#exists?(#{path})" }
        @application.exists?(path)
      end

      def file_info(path)
        logger.debug { "FTPMVC::Ftpd::FileSystem#file_info(#{path})" }
        ::Ftpd::FileInfo.new(
          :ftype => directory?(path) ? 'directory' : 'file',
          :group => 'nogroup',
          :mode => directory?(path) ? 0750 : 0640,
          :mtime => Time.now,
          :nlink => 33,
          :owner => 'nobody',
          :path => path,
          :size => 0)
      end
    end
  end
end
