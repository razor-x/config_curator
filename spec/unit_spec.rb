require 'spec_helper'

describe ConfigCurator::Unit do

  subject(:unit) { ConfigCurator::Unit.new }

  describe ".new" do

    it "sets default options" do
      expect(unit.options).to eq ConfigCurator::Unit::DEFAULT_OPTIONS
    end

    it "merges default options" do
      unit = ConfigCurator::Unit.new options: {root: '/home/user'}
      expect(unit.options).to eq ConfigCurator::Unit::DEFAULT_OPTIONS.merge(root: '/home/user')
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

  describe ".hosts" do

    it "is empty by default" do
      expect(unit.hosts).to eq []
    end
  end

  describe ".packages" do

    it "is empty by default" do
      expect(unit.packages).to eq []
    end
  end
end
