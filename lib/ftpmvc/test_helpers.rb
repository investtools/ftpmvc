require 'net/ftp'
require 'ftpmvc/server'

module FTPMVC
  module TestHelpers
    def with_application(app)
      server = FTPMVC::Server.new('127.0.0.1', 0).start_in_new_thread(app)
      begin
        ftp = Net::FTP.new
        begin
          ftp.connect('127.0.0.1', server.port)
          yield ftp
        ensure
          ftp.close
        end
      ensure
        server.stop
      end
    end

    def get(ftp, path)
      ''.tap do |response|
        ftp.retrbinary("RETR #{path}", 1024) do |block|
          response << block
        end
      end
    end
  end
end
