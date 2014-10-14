require 'ftpmvc'
require './env_directory'

app = FTPMVC::Application.new do
  filesystem do
    directory :system do
      directory :env
    end
  end
end

FTPMVC::Server.new(2222).start(app)
