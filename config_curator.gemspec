# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'config_curator/version'

Gem::Specification.new do |spec|
  spec.name          = 'config_curator'
  spec.version       = ConfigCurator::VERSION
  spec.authors       = ['Evan Boyd Sosenko']
  spec.email         = ['razorx@evansosenko.com']
  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = 'https://github.com/razor-x/config_curator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
