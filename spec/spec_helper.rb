require 'simplecov'
require 'codecov'

SimpleCov.start

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Codecov
]

require 'replace_gemname'

RSpec.configure do |c|
  c.expect_with(:rspec) { |e| e.syntax = :expect }
  c.before(:each) do
    allow(FileUtils).to receive(:remove_entry_secure).with(anything)
  end
end
