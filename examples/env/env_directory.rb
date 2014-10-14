require './env_file'

class EnvDirectory < FTPMVC::Directory
  def index
    ENV.keys.map { |var_name| EnvFile.new(var_name) }
  end
end
