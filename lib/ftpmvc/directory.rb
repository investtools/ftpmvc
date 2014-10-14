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
      if Object.const_defined?(specific_handler_class_name(name))
        instance = Object::const_get(specific_handler_class_name(name)).new(name, &block)
      else
        instance = self.new(name, &block)
      end
    end

    def directory(name, &block)
      Directory.build(name, &block).tap do |directory|
        @index << directory
      end
    end

    def directory?(path)
      resolve(path).kind_of?(Directory)
    end

    protected

    def self.specific_handler_class_name(name)
      "#{name.to_s.camelize}Directory"
    end
  end
end
