require './spec/spec_helper'

require 'ftpmvc/server'

describe FTPMVC::Server do
  describe '#start' do
    let(:server) { FTPMVC::Server.new('127.0.0.1', 0) }
    it 'starts the FTP server' do
      server.start(FTPMVC::Directory.new('/')) do
        begin
          socket = TCPSocket.new('127.0.0.1', server.port)
          socket.close
        rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL => e
          fail "Cannnot connect to server! (#{e.class}: #{e.message})"
        ensure
          server.stop
        end
      end
    end
  end
end