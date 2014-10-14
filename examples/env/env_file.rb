class EnvFile < FTPMVC::File
  def initialize(var_name)
    @var_name = var_name
    super "#{var_name}.txt"
  end

  def data
    StringIO.new(ENV[@var_name])
  end
end
