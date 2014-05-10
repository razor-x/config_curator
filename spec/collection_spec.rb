require 'spec_helper'

describe ConfigCurator::Collection do

  subject(:collection) { ConfigCurator::Collection.new }

  describe ".new" do

    it "sets the logger" do
      logger = Logger.new(STDOUT)
      collection = ConfigCurator::Collection.new logger: logger
      expect(collection.logger).to be logger
    end

    it "loads the manifest" do
      expect(YAML).to receive(:load_file).with('path')
      ConfigCurator::Collection.new manifest_path: 'path'
    end
  end

  describe "#logger" do

    it "makes a new logger" do
      expect(collection.logger).to be_a Logger
    end
  end

  describe "#load_manifest" do

    let(:manifest) { {root: 'tmp'} }

    it "loads the manifest" do
      path = 'path/to/manifest'
      allow(YAML).to receive(:load_file).with(path).and_return(manifest)
      expect(collection.load_manifest path).to eq manifest
      expect(collection.manifest).to eq manifest
    end
  end

  describe "#create_unit" do

    subject(:unit) { collection.create_unit :unit }

    it "makes a new unit" do
      expect(unit).to be_a ConfigCurator::Unit
    end

    it "sets the unit's logger" do
      expect(unit.logger).to be collection.logger
    end

    context "with basic attributes" do

      let(:attributes) { {src: 'src', dst: 'dest'} }
      subject(:unit) { collection.create_unit :unit, attributes: attributes }

      it "sets the source" do
        expect(unit.source).to eq 'src'
      end

      it "sets the destination" do
        expect(unit.destination).to eq 'dest'
      end
    end

    context "with unit specific attributes" do

      let(:attributes) { {src: 'src', dst: 'dest', fmode: '0600', owner: 'username'} }
      subject(:unit) { collection.create_unit :component, attributes: attributes }

      it "sets the generic attributes" do
        expect(unit.destination).to eq 'dest'
        expect(unit.source).to eq 'src'
      end

      it "sets the unit specific attributes" do
        expect(unit.fmode).to eq '0600'
        expect(unit.owner).to eq 'username'
      end
    end

    context "with manifest" do

      let(:manifest) do
        YAML.load <<-EOF
          :root: /tmp
          :package_tool: :pacman
          :defaults:
            :fmode: '0640'
            :dmode: '0750'
            :owner: username
            :group: groupname
        EOF
      end
      let(:attributes) { {src: 'src', dst: 'dest', dmode: '0700'} }
      subject(:unit) { collection.create_unit :component, attributes: attributes }

      before(:each) { collection.manifest = manifest }

      it "sets the unit's root path" do
        expect(unit.options[:root]).to eq manifest[:root]
      end

      it "sets the unit's package tool" do
        expect(unit.options[:package_tool]).to eq manifest[:package_tool]
      end

      it "sets the unit specific attributes" do
        expect(unit.dmode).to eq '0700'
      end

      it "sets attribute defaults from the manifest" do
        expect(unit.owner).to eq 'username'
        expect(unit.group).to eq 'groupname'
      end
    end
  end

  describe "#units" do

    let(:types) do
      types = ConfigCurator::Collection::UNIT_TYPES
      types.map { |t| "#{t}s".to_sym }
    end

    context "no manifest" do

      it "has a key for each supported unit type" do
        types.each do |type|
          expect(collection.units.key? type).to be true
        end
      end

      it "sets each entry empty" do
        types.each do |type|
          expect(collection.units[type]).to be_a Array
          expect(collection.units[type]).to be_empty
        end
      end
    end

    context "with manifest" do

      let(:manifest) do
        YAML.load <<-EOF
          :defaults:
            :dmode: '0700'
          :components:
            - :src: components/component_1
              :dst: inst/component_1
              :fmode: '0600'
            - :src: components/component_2
          :config_files:
            - :src: conf_file
        EOF
      end

      before(:each) { collection.manifest = manifest }

      it "has a key for each supported unit type" do
        types.each do |type|
          expect(collection.units.key? type).to be true
        end
      end

      it "sets entries for missing unit types empty" do
        %i(units symlinks).each do |type|
          expect(collection.units[type]).to be_empty
        end
      end

      it "contains units" do
        expect(collection.units[:components]).to_not be_empty
        collection.units[:components].each do |unit|
          expect(unit).to be_a ConfigCurator::Component
        end

        expect(collection.units[:config_files]).to_not be_empty
        collection.units[:config_files].each do |unit|
          expect(unit).to be_a ConfigCurator::ConfigFile
        end
      end

      it "creates units with correct attributes" do
        component = collection.units[:components].first
        expect(component.source).to eq 'components/component_1'
        expect(component.destination).to eq 'inst/component_1'
        expect(component.fmode).to eq '0600'
        expect(component.dmode).to eq '0700'
      end
    end
  end

  describe "#install" do

    let(:manifest) do
      YAML.load <<-EOF
        :components:
          - :src: components/component_1
            :dst: inst/component_1
          - :src: components/component_2
            :dst: inst/component_2
        :config_files:
          - :src: conf_file
      EOF
    end

    before(:each) { collection.manifest = manifest }

    let(:units) { collection.units }

    context "when #install? is true" do

      it "calls #install on each unit and returns true" do
        allow(collection).to receive(:install?).and_return(true)
        expect(units[:components][0]).to receive(:install)
        expect(units[:components][1]).to receive(:install)
        expect(units[:config_files][0]).to receive(:install)
        expect(collection.install).to be true
      end
    end

    context "when #install? is false" do

      it "does not call #install on each unit and returns false" do
        allow(collection).to receive(:install?).and_return(false)
        expect(units[:components][0]).to_not receive(:install)
        expect(units[:components][1]).to_not receive(:install)
        expect(units[:config_files][0]).to_not receive(:install)
        expect(collection.install).to be false
      end
    end

    context "when component install fails" do

      it "stops installing and returns nil" do
        allow(collection).to receive(:install?).and_return(true)
        expect(units[:components][0]).to receive(:install)
        expect(units[:components][1]).to receive(:install).and_raise ConfigCurator::Unit::InstallFailed
        expect(units[:config_files][0]).to_not receive(:install)
        expect(collection.install).to be nil
      end
    end
  end

  describe "#install?" do

    let(:manifest) do
      YAML.load <<-EOF
        :components:
          - :src: components/component_1
            :dst: inst/component_1
          - :src: components/component_2
            :dst: inst/component_2
        :config_files:
          - :src: conf_file
      EOF
    end

    before(:each) { collection.manifest = manifest }

    let(:units) { collection.units }

    context "when no errors" do

      it "calls #install? on each unit and returns true" do
        expect(units[:components][0]).to receive(:install?)
        expect(units[:components][1]).to receive(:install?)
        expect(units[:config_files][0]).to receive(:install?)
        expect(collection.install?).to be true
      end
    end

    context "when install error" do

      it "calls #install? on each unit and returns false" do
        allow(units[:components][0]).to receive(:install?)
        .and_raise(ConfigCurator::Unit::InstallFailed)
        allow(units[:components][1]).to receive(:install?)
        allow(units[:config_files][0]).to receive(:install?)
        expect(collection.install?).to be false
      end
    end
  end
end
