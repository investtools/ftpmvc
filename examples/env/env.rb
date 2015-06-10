require 'ftpmvc'
require './env_directory'

app = FTPMVC::Application.new do
  filesystem do
    directory name: 'system' do
      directory :env
    end
  end
end

FTPMVC::Server.new(2121).start(app) do |server|
  puts "Server listening on #{server.host}:#{server.port}..."
end

