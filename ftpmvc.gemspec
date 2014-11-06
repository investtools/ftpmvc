# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ftpmvc/version'

Gem::Specification.new do |spec|
  spec.name          = "ftpmvc"
  spec.version       = FTPMVC::VERSION
  spec.authors       = ["André Aizim Kelmanson"]
  spec.email         = ["akelmanson@gmail.com"]
  spec.summary       = "FTP MVC framework"
  spec.description   = "FTP MVC framework"
  spec.homepage      = "https://github.com/investtools/ftpmvc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_dependency "ftpd"
  spec.add_dependency "activesupport"
end
