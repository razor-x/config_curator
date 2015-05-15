require 'spec_helper'

describe ConfigCurator::ConfigFile do
  subject(:config_file) { ConfigCurator::ConfigFile.new }

  describe "#destination" do
    let(:source) { 'path/../src_name.ext' }

    it "uses the source path to set the destination" do
      config_file.source = source
      expect(config_file.destination).to eq source
    end

    context "when host-specific file found" do
      it "uses the source path to set the destination" do
        config_file.source = source
        allow(config_file).to receive(:search_for_host_specific_file).with(source)
          .and_return('path/../src_name.hostname.ext')
        expect(config_file.destination).to eq source
      end
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

  describe "#uninstall" do
    context "when config file should be uninstalled" do
      it "uninstalls the config file and returns true" do
        expect(config_file).to receive(:uninstall?).and_return(true)
        expect(config_file).to receive(:uninstall_file)
        expect(config_file.uninstall).to be true
      end
    end

    context "when config file should not be uninstalled" do
      it "does not uninstall the config file and returns false" do
        expect(config_file).to receive(:uninstall?).and_return(false)
        expect(config_file).to_not receive(:uninstall_file)
        expect(config_file.uninstall).to be false
      end
    end
  end

  describe "#install" do
    context "when config file should be installed" do
      it "installs the config file and returns true" do
        expect(config_file).to receive(:install?).and_return(true)
        expect(config_file).to receive(:install_file)
        expect(config_file).to receive(:set_mode)
        expect(config_file).to receive(:set_owner)
        expect(config_file.install).to be true
      end
    end

    context "when config file should not be installed" do
      it "does not install the config file and returns false" do
        expect(config_file).to receive(:install?).and_return(false)
        expect(config_file).to_not receive(:install_file)
        expect(config_file).to_not receive(:set_mode)
        expect(config_file).to_not receive(:set_owner)
        expect(config_file.install).to be false
      end
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
