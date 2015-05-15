require 'spec_helper'

describe ConfigCurator::Unit do
  subject(:unit) { ConfigCurator::Unit.new }

  describe ".new" do
    it "sets the logger" do
      logger = Logger.new(STDOUT)
      unit = ConfigCurator::Unit.new logger: logger
      expect(unit.logger).to be logger
    end

    it "sets default options" do
      expect(unit.options).to eq ConfigCurator::Unit::DEFAULT_OPTIONS
    end

    it "merges default options" do
      unit = ConfigCurator::Unit.new options: {root: '/home/user'}
      expect(unit.options).to eq ConfigCurator::Unit::DEFAULT_OPTIONS.merge(root: '/home/user')
    end
  end

  describe "#logger" do
    it "makes a new logger" do
      expect(unit.logger).to be_a Logger
    end
  end

  describe "#options" do
    it "merges with default options" do
      unit.options[:root] = '/home/user'
      expect(unit.options).to eq ConfigCurator::Unit::DEFAULT_OPTIONS.merge(root: '/home/user')
    end

    it "can be called twice and merge options" do
      unit.options[:root] = '/home/user'
      unit.options[:perm] = 0600
      expect(unit.options).to eq ConfigCurator::Unit::DEFAULT_OPTIONS.merge(root: '/home/user', perm: 0600)
    end
  end

  describe "#source_path" do
    it "expands the path" do
      unit.source = 'path/../src_name'
      expect(unit.source_path).to eq File.expand_path('path/../src_name')
    end

    context "when no source given" do
      it "returns nil" do
        expect(unit.source_path).to eq nil
      end
    end
  end

  describe "#destination_path" do
    it "expands the path" do
      unit.destination = 'path/../dest_name'
      unit.options[:root] = '/tmp'
      expect(unit.destination_path).to eq '/tmp/dest_name'
    end

    context "when no destination given" do
      it "returns nil" do
        expect(unit.destination_path).to eq nil
      end
    end
  end

  describe "#hosts" do
    it "is empty by default" do
      expect(unit.hosts).to be_a Array
      expect(unit.hosts).to be_empty
    end
  end

  describe "#packages" do
    it "is empty by default" do
      expect(unit.packages).to be_a Array
      expect(unit.packages).to be_empty
    end
  end

  describe "#package_lookup" do
    it "returns a PackageLookup object" do
      expect(unit.package_lookup).to be_a ConfigCurator::PackageLookup
    end

    it "sets the correct package tool" do
      unit.options[:package_tool] = :pkg_tool
      expect(unit.package_lookup.tool).to eq :pkg_tool
    end
  end

  describe "#install" do
    context "when unit should be installed" do
      it "returns true" do
        expect(unit).to receive(:install?).and_return(true)
        expect(unit.install).to be true
      end
    end

    context "when unit should not be installed" do
      it "returns false" do
        expect(unit).to receive(:install?).and_return(false)
        expect(unit.install).to be false
      end
    end
  end

  describe "#install?" do
    it "checks if host is allowed" do
      expect(unit).to receive(:allowed_host?)
      unit.install?
    end

    it "checks if package requirements are met" do
      expect(unit).to receive(:packages_installed?)
      unit.install?
    end

    context "when requirements are met" do
      it "returns true" do
        expect(unit).to receive(:allowed_host?).and_return(true)
        expect(unit).to receive(:packages_installed?).and_return(true)
        expect(unit.install?).to be true
      end
    end

    context "when not on an allowed host" do
      it "returns false" do
        expect(unit).to receive(:allowed_host?).and_return(false)
        expect(unit.install?).to be false
      end
    end

    context "when required packages are not installed" do
      it "returns false" do
        expect(unit).to receive(:packages_installed?).and_return(false)
        expect(unit.install?).to be false
      end
    end
  end

  describe "#allowed_host?" do
    context "when hosts are given" do
      it "allows host if host is listed" do
        allow(unit).to receive(:hostname).and_return('test_hostname')
        unit.hosts = %w(some_host test_hostname)
        expect(unit.allowed_host?).to eq true
      end

      it "does not allow unlisted host" do
        allow(unit).to receive(:hostname).and_return('bad_test_hostname')
        unit.hosts = %w(some_host test_hostname)
        expect(unit.allowed_host?).to eq false
      end
    end

    context "when no hosts are given" do
      it "allows any host" do
        unit.hosts = []
        expect(unit.allowed_host?).to eq true
      end
    end
  end

  describe "#packages_installed?" do
    context "when packages listed" do
      it "meets package requirements if no missing packages" do
        allow(unit).to receive(:pkg_exists?).with('good_pkg_1').and_return(true)
        allow(unit).to receive(:pkg_exists?).with('good_pkg_2').and_return(true)
        unit.packages = %w(good_pkg_1 good_pkg_2)
        expect(unit.packages_installed?).to eq true
      end

      it "does not meet package requirements if missing packages" do
        allow(unit).to receive(:pkg_exists?).with('good_pkg').and_return(true)
        allow(unit).to receive(:pkg_exists?).with('bad_pkg').and_return(false)
        unit.packages = %w(good_pkg bad_pkg)
        expect(unit.packages_installed?).to eq false
      end
    end

    context "when no packages listed" do
      it "meets package requirements" do
        unit.packages = []
        expect(unit.packages_installed?).to eq true
      end
    end
  end
end
