require 'active_support/dependencies'
require 'active_support/core_ext/string/inflections'

module FTPMVC
  class Directory
    attr_reader :name, :index

    def initialize(name, &block)
      @name = name.to_s
      @index = []
      instance_eval(&block) if block_given?
    end

    def size(path)
      io = get(path)
      return nil if io.nil?
      total_size = 0
      while buffer = io.read(1024)
        total_size += buffer.size
      end
      total_size
    end

    def get(path)
      file = resolve(path)
      file ? file.data : nil
    end

    def resolve(path)
      path = path.gsub(%r{^/}, '')
      return self if path.empty?
      name, subpath = path.split('/', 2)
      child = index.find { |node| node.name == name }
      if subpath == nil or child == nil
        child
      else
        child.resolve(subpath)
      end
    end

    def self.build(name, &block)
      directory_class(name).new(name, &block)
    end

    def directory?(path)
      resolve(path).kind_of?(Directory)
    end

    protected

    def directory(name, &block)
      Directory.build(name, &block).tap do |directory|
        @index << directory
      end
    end

    def self.directory_class(name)
      ActiveSupport::Dependencies.safe_constantize("#{name.to_s.camelize}Directory") || self
    end
  end
end
