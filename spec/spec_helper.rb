require 'coveralls'
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start

require 'replace_gemname'

RSpec.configure do |c|
  c.expect_with(:rspec) { |e| e.syntax = :expect }
  c.before(:each) do
    allow(FileUtils).to receive(:remove_entry_secure).with(anything)
  end
end
