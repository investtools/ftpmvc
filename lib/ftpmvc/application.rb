require 'ftpmvc/directory'
require 'ftpmvc/filter'
require 'ftpmvc/access_filesystem_filter'

module FTPMVC
  class Application
    extend Forwardable

    def_delegators :@filter_chain, :index, :size, :get, :directory?

    def initialize(&block)
      @fs = FTPMVC::Directory.new('/')
      @filter_chain = AccessFilesystemFilter.new(@fs, nil)
      instance_eval(&block)
    end

    protected

    def filter(filter_class, options={})
      @filter_chain = filter_class.new(@fs, @filter_chain, options)
    end

    def filesystem(&block)
      @fs.instance_eval(&block)
    end
  end
end
