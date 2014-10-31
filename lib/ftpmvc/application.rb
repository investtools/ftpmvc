require 'forwardable'
require 'ftpmvc/directory'
require 'ftpmvc/filter'
require 'ftpmvc/access_filesystem_filter'
require 'ftpmvc/authenticator/promiscuous'

module FTPMVC
  class Application
    extend Forwardable

    def_delegators :@filter_chain, :index, :size, :get, :directory?
    def_delegators :auth, :authenticate

    def initialize(&block)
      @fs = Directory.new('/')
      @filter_chain = AccessFilesystemFilter.new(@fs, nil)
      instance_eval(&block) if block_given?
    end

    protected

    def auth
      @authenticator ||= Authenticator::Promiscuous.new
    end

    def filter(filter_class, options={})
      @filter_chain = filter_class.new(@fs, @filter_chain, options)
    end

    def authenticator(authenticator)
      @authenticator = authenticator
    end

    def filesystem(&block)
      @fs.instance_eval(&block)
    end
  end
end
