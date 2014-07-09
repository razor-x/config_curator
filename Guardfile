scope groups: [:doc, :lint, :unit]

group :doc do
  guard :yard do
    watch(%r{^lib/(.+)\.rb$})
  end
end

group :lint do
  guard :rubocop do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end

group :unit do
  guard :rspec, cmd: 'bundle exec rspec --color --format Fuubar' do
    watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^lib/config_curator/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^spec/.+_spec\.rb$})
    watch('spec/spec_helper.rb') { 'spec' }
  end
end
