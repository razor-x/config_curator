require 'spec_helper'

describe ConfigCurator::ConfigFile do

  subject(:config_file) { ConfigCurator::ConfigFile.new }

  describe "#destination" do

    it "uses the source path to set the destination" do
      config_file.source = 'path/to/file'
      expect(config_file.destination).to eq 'path/to/file'
    end
  end

  describe "#source" do

    context "when host-specific file not found" do

      let(:source) { 'path/../src_name.ext' }

      it "returns the source path" do
        config_file.source = source
        allow(config_file).to receive(:search_for_host_specific_file).with(source)
        .and_return(nil)
        expect(config_file.source).to eq source
      end
    end

    context "when host-specific file found" do

      let(:source) { 'path/../src_name.ext' }

      it "returns the host-specific source path" do
        config_file.source = source
        allow(config_file).to receive(:search_for_host_specific_file).with(source)
        .and_return('path/../src_name.hostname.ext')
        expect(config_file.source).to eq 'path/../src_name.hostname.ext'
      end
    end
  end

  describe "#install" do

    it "installs the config file" do
      allow(File).to receive(:exists?).and_return(true)
      config_file.source = 'file'
      config_file.destination = 'dest'
      expect(config_file).to receive(:install_file)
      expect(config_file).to receive(:set_mode)
      expect(config_file).to receive(:set_owner)
      config_file.install
    end
  end

  describe "#install?" do

    context "when source not given" do

      it "fails" do
        expect { config_file.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
      end
    end

    context "when source does not exist" do

      it "fails" do
        config_file.source = 'dir/that/does/not/exist'
        expect { config_file.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
      end
    end
  end
end
