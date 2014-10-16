require 'em-ftpd'
require 'ftpmvc/driver'

module FTPMVC
  class Server

    attr_reader :host, :port
  
    def initialize(host='0.0.0.0', port)
      @host, @port = host, port
    end

    def start_in_new_thread(application)
      queue = Queue.new
      server_thread = Thread.new do
        begin
          start(application) do
            queue << true
          end
        rescue => e
          $strerr.puts "Server error: #{e.class}: #{e.message}"
        end
      end
      queue.pop
    end

    def start(application)
      EM.epoll
      EM::run do
        @signature = EM::start_server(@host, @port, EM::FTPD::Server, Driver, application)
        @port = Socket.unpack_sockaddr_in(EM.get_sockname(@signature)).first
        yield self if block_given?
      end
    end
    
    def stop
      EM.stop_server(@signature)
    end
  end
end
