require 'simplecov'

SimpleCov.start

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
else
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
end

require 'replace_gemname'

RSpec.configure do |c|
  c.expect_with(:rspec) { |e| e.syntax = :expect }
  c.before(:each) do
    allow(FileUtils).to receive(:remove_entry_secure).with(anything)
  end
end
