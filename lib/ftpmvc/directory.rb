require 'active_support/dependencies'
require 'active_support/core_ext/string/inflections'

module FTPMVC
  class Directory
    attr_reader :name, :index

    def initialize(options={}, &block)
      @name = options[:name]
      @index = []
      instance_eval(&block) if block_given?
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

    protected

    def directory(*args, &block)
      first_arg, second_arg = args
      
      if first_arg.kind_of?(self.class)
        add_directory(first_arg)
      else
        if first_arg.kind_of?(Hash)
          create_and_add_directory(self.class, first_arg, &block)
        else
          create_and_add_directory(first_arg, second_arg || {}, &block)
        end
      end
    end

    def create_and_add_directory(dir, options, &block)
      if dir.kind_of?(Symbol)
        options[:name] = options[:name] || dir.to_s
        dir = symbol_to_class(dir)
      end
      add_directory(create_directory(dir, options, &block))
    end

    def add_directory(dir)
      dir.tap { |directory| @index << directory }
    end

    def create_directory(dir_class, options, &block)
      dir_class.new(options, &block)
    end

    def symbol_to_class(symbol)
      ActiveSupport::Dependencies.safe_constantize("#{symbol.to_s.camelize}Directory")
    end
  end
end
