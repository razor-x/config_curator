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

    context "when tool is set" do

      it "returns the tool" do
        lookup.tool = :pacman
        expect(lookup.tool).to eq :pacman
      end
    end

    context "when tool not set" do

      it "returns the first avaible tool" do
        lookup.tools = {dpkg: 'dpkg', pacman: 'pacman'}
        allow(lookup).to receive(:command?).with('dpkg').and_return(true)
        expect(lookup.tool).to eq :dpkg
      end
    end
  end

  describe "#installed?" do

    context "when package is found" do

      it "calls the corresponding private lookup method and returns true" do
        lookup.tool = :dpkg
        cmd = lookup.tools[:dpkg]
        allow(lookup).to receive(:command?).with(cmd).and_return(cmd)
        expect(lookup).to receive(:dpkg).with('rsync').and_return(true)
        expect(lookup.installed? 'rsync').to be true
      end
    end

    context "when package not found" do

      it "calls the corresponding private lookup method and returns false" do
        lookup.tool = :dpkg
        cmd = lookup.tools[:dpkg]
        allow(lookup).to receive(:command?).with(cmd).and_return(cmd)
        expect(lookup).to receive(:dpkg).with('rsync').and_return(false)
        expect(lookup.installed? 'rsync').to be false
      end
    end

    context "when no package tool found" do

      it "fails" do
        lookup.tools = {dpkg: 'dpkg'}
        allow(lookup).to receive(:command?).with('dpkg').and_return(nil)
        expect { lookup.installed? 'rsync' }.to raise_error ConfigCurator::PackageLookup::LookupFailed
      end
    end

    context "when package tool not found" do

      it "fails" do
        lookup.tool = :dpkg
        cmd = lookup.tools[:dpkg]
        allow(lookup).to receive(:command?).with(cmd).and_return(nil)
        expect { lookup.installed? 'rsync' }.to raise_error ConfigCurator::PackageLookup::LookupFailed
      end
    end
  end
end
