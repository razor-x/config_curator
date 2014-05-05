require 'spec_helper'

describe ConfigCurator::Symlink do

  subject(:symlink) { ConfigCurator::Symlink.new }

  describe "#source_path" do

    it "returns nil if no source given" do
      expect(symlink.source_path).to eq nil
    end

    it "expands the path" do
      symlink.source = 'path/../src_name'
      expect(symlink.source_path).to eq File.expand_path('path/../src_name')
    end
  end

  describe "#link_path" do

    it "returns nil if no destination given" do
      expect(symlink.link_path).to eq nil
    end

    it "expands the path" do
      symlink.destination = 'path/../link_name'
      symlink.options[:root] = '/tmp'
      expect(symlink.link_path).to eq '/tmp/link_name'
    end
  end

  describe "#install" do

    it "makes a symbolic link" do
      allow(File).to receive(:exists?).and_return(true)
      symlink.source = 'file'
      symlink.destination = 'link'
      expect(symlink).to receive(:symlink)
      symlink.install
    end
  end

  describe "#install?" do

    it "fails when source not given" do
      symlink.destination = 'link_path'
      expect { symlink.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
    end

    it "fails when destination not given" do
      symlink.source = 'file'
      expect { symlink.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
    end

    it "fails when source does not exist" do
      symlink.destination = 'link_path'
      symlink.source = 'path/that/does/not/exist'
      expect { symlink.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
    end
  end
end
