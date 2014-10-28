if ENV.include?('CODECLIMATE_REPO_TOKEN')
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'ftpmvc/test_helpers'

RSpec.configure do |config|
  config.include FTPMVC::TestHelpers
  config.before :each do
    ActiveSupport::Dependencies.clear
  end
end