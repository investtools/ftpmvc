require 'ftpd'
require 'ftpmvc/ftpd'

module FTPMVC
  class Server

    attr_reader :host, :port
  
    def initialize(host='0.0.0.0', port)
      @host, @port = host, port
    end

    def start_in_new_thread(application)
      driver = Ftpd::Driver.new(application)
      @server = ::Ftpd::FtpServer.new(driver)
      @server.interface, @server.port = @address, @port
      @server.start
      @port = @server.bound_port
      self
    end

    def start(application)
      start_in_new_thread(application)
      yield self if block_given?
      # Manter o instance_variable_get até o pull request #29 ser aprovado
      # o uma nova versão ficar disponível.
      @server.instance_variable_get(:@server_thread).join
      # @server.join
    end
    
    def stop
      @server.stop
    end
  end
end
