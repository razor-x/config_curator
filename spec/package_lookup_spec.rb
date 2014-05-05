require 'spec_helper'

describe ConfigCurator::PackageLookup do

  subject(:lookup) { ConfigCurator::PackageLookup.new }

  describe ".new" do

    it "sets the package tool" do
      lookup = ConfigCurator::PackageLookup.new tool: :dpkg
      expect(lookup.tool).to eq :dpkg
    end
  end

  describe "#tools" do

    it "uses the default list of tools" do
      expect(lookup.tools).to eq ConfigCurator::PackageLookup::TOOLS
    end
  end

  describe "#tool" do

    it "returns the tool when set" do
      lookup.tool = :pacman
      expect(lookup.tool).to eq :pacman
    end

    it "returns the first avaible tool when not set" do
      allow(lookup).to receive(:command?).with(:dpkg).and_return(true)
      lookup.tools = %i(dpkg pacman)
      expect(lookup.tool).to eq :dpkg
    end
  end

  describe "#installed?" do

    it "calls the corresponding private lookup method" do
      lookup.tool = :dpkg
      expect(lookup).to receive(:dpkg).with('rsync')
      lookup.installed? 'rsync'
    end

    it "fails when no package tool found" do
      lookup.tools = %i(dpkg)
      allow(lookup).to receive(:command?).with(:dpkg).and_return(false)
      expect { lookup.installed? 'rsync' }.to raise_error ConfigCurator::PackageLookup::LookupFailed
    end
  end
end
