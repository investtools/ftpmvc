require 'forwardable'
require 'ftpmvc/directory'
require 'ftpmvc/filter'
require 'ftpmvc/access_filesystem_filter'
require 'ftpmvc/authenticator/promiscuous'

module FTPMVC
  class Application
    extend Forwardable

    def_delegators :@filter_chain, :index, :get, :directory?, :exists?
    def_delegators :auth, :authenticate

    def initialize(&block)
      @fs = Directory.new('/')
      @filter_chain = AccessFilesystemFilter.new(@fs, nil)
      instance_eval(&block) if block_given?
    end

    def auth
      @authenticator ||= Authenticator::Promiscuous.new
    end

    protected

    def filter(filter_class, options={})
      @filter_chain = filter_class.new(@fs, @filter_chain, options)
    end

    def authenticator(authenticator, options={})
      if authenticator.kind_of?(Symbol)
        authenticator = FTPMVC::Authenticator.const_get(authenticator.to_s.camelize)
      end
      if authenticator.kind_of?(Class)
        authenticator = authenticator.new(options)
      end
      @authenticator = authenticator
    end

    def filesystem(&block)
      @fs.instance_eval(&block)
    end
  end
end
