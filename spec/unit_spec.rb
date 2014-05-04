require 'spec_helper'

describe ConfigCurator::Unit do

  describe ".new" do

    subject(:unit) { ConfigCurator::Unit.new }

    it "sets default options" do
      expect(unit.options).to eq ConfigCurator::Unit::DEFAULT_OPTIONS
    end

    it "merges default options" do
      unit = ConfigCurator::Unit.new options: {root: '/home/user'}
      expect(unit.options).to eq ConfigCurator::Unit::DEFAULT_OPTIONS.merge(root: '/home/user')
    end
  end

  describe "#options" do

    subject(:unit) { ConfigCurator::Unit.new }

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
end
