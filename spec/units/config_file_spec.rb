require 'spec_helper'

describe ConfigCurator::ConfigFile do

  subject(:config_file) { ConfigCurator::ConfigFile.new }

  describe "#destination" do

    it "uses the source path to set the destination" do
      config_file.source = 'path/to/file'
      expect(config_file.destination).to eq 'path/to/file'
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

    it "fails when source not given" do
      expect { config_file.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
    end

    it "fails when source does not exist" do
      config_file.source = 'dir/that/does/not/exist'
      expect { config_file.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
    end
  end
end
