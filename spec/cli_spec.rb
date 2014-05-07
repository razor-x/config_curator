require 'spec_helper'

describe ConfigCurator::CLI do

  subject(:cli) { ConfigCurator::CLI.new }

  describe "#collection" do

    it "makes a new collection" do
      expect(cli.collection).to be_a ConfigCurator::Collection
    end

    it "sets the logger for the collection" do
      expect(cli.collection.logger).to be cli.logger
    end
  end

  describe "#logger" do

    it "makes a new logger" do
      expect(cli.logger).to be_a Logger
    end
  end
end
