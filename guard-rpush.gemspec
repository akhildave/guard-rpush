# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/rpush/version'

Gem::Specification.new do |spec|
  spec.name          = "guard-rpush"
  spec.version       = Guard::RpushVersion::VERSION
  spec.authors       = ["akhildave"]
  spec.email         = ["akhiltheway@gmail.com"]
  spec.summary       = %q{Guard plugin for rpush.}
  spec.description   = %q{Guard::Rpush automatically starts and restarts your local rpush daemon.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_dependency 'guard',        '~> 2.6'
  spec.add_dependency 'guard-compat', '~> 1.1' 
end
