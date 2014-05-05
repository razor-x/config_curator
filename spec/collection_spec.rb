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

    it "should make a new logger" do
      expect(collection.logger).to be_a Logger
    end
  end

  describe "methods that use the manifest" do

    let(:manifest) do
      YAML.load <<-EOF
        :options:
          :log_level: :info
          :root: /tmp
        :defaults:
          :fmode: 0640
          :dmode: 0750
          :user: username
          :group: groupname
        :components:
          - :src: components/component
            :dst: inst/component
        :files:
          - :src: conf_file
        :symlinks:
          - :src: src/file
            :dst: path/to/link
      EOF
    end

    describe "#load_manifest" do

      it "loads the manifest" do
        path = 'path/to/manifest'
        allow(YAML).to receive(:load_file).with(path).and_return(manifest)
        expect(collection.load_manifest path).to eq manifest
        expect(collection.manifest).to eq manifest
      end
    end
  end
end
