guard :rspec, cmd: 'bundle exec rspec --color --format Fuubar' do
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/config_curator/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb') { 'spec' }
end

guard :yard do
  watch(%r{^lib/(.+)\.rb$})
end
