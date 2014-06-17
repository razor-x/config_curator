lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'replace_gemname/version'

Gem::Specification.new do |spec|
  spec.name          = 'replace_gemname'
  spec.version       = ReplaceGemname::VERSION
  spec.authors       = ['replace_author']
  spec.email         = ['replace@example.com']
  spec.description   = %q{ReplaceDescription.}
  spec.summary       = %q{ReplaceSummary.}
  spec.homepage      = 'https://github.com/replace_user/replace_gemname'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(features|spec|test)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'bump', '~> 0.5.0'

  spec.add_development_dependency 'yard', '~> 0.8.7.4'
  spec.add_development_dependency 'yard-redcarpet-ext', '~> 0.0.3'
  spec.add_development_dependency 'redcarpet', '~> 3.1.2'
  spec.add_development_dependency 'github-markup', '1.2.1'

  spec.add_development_dependency 'rubocop', '~> 0.23.0'

  spec.add_development_dependency 'rake', '~> 10.3.2'

  spec.add_development_dependency 'guard', '~> 2.6.1'
  spec.add_development_dependency 'guard-yard', '~> 2.1.0'
  spec.add_development_dependency 'guard-rubocop', '~> 1.1.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.2.9'

  spec.add_development_dependency 'rspec', '~> 3.0.0'
  spec.add_development_dependency 'simplecov', '~> 0.8.2'
  spec.add_development_dependency 'coveralls', '~> 0.7.0'
  spec.add_development_dependency 'fuubar', '~> 2.0.0.rc1'
end
