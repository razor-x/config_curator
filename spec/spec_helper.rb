require 'config_curator'

require 'coveralls'
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start

RSpec.configure do |c|
  c.expect_with(:rspec) { |e| e.syntax = :expect }

  stderr = $stderr
  stdout = $stdout
  c.before(:all) do
    $stderr = File.open File::NULL, 'w'
    $stdout = File.open File::NULL, 'w'
  end
  c.after(:all) do
    $stderr = stderr
    $stdout = stdout
  end

  c.before(:each) { allow(FileUtils).to receive(:remove_entry_secure).with(anything) }
end
