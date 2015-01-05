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

    def get(path)
      file = resolve(path)
      file ? file.data : nil
    end

    def put(path, stream)
      puts 'foooi!!!'
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
