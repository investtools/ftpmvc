require 'em-ftpd'
require 'ftpmvc/driver'

module FTPMVC
  class Server

    attr_reader :port
  
    def initialize(host='0.0.0.0', port)
      @host, @port = host, port
    end

    def start(root)
      EventMachine.epoll
      EventMachine::run do
        signature = EventMachine::start_server(@host, @port, EM::FTPD::Server, Driver, root)
        @port = Socket.unpack_sockaddr_in(EM.get_sockname(signature)).first
        puts "Server listening on #{@host}:#{@port}..."
        yield if block_given?
      end
    end
    
    def stop
      EM.stop
    end
  end
end
