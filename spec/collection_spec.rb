require 'spec_helper'

describe ConfigCurator::Collection do

  subject(:collection) { ConfigCurator::Collection.new }

  describe ".new" do

    it "sets the logger" do
      logger = Logger.new(STDOUT)
      collection = ConfigCurator::Collection.new logger: logger
      expect(collection.logger).to be logger
    end
  end

  describe "#logger" do

    it "should make a new logger" do
      expect(collection.logger).to be_a Logger
    end
  end
end
