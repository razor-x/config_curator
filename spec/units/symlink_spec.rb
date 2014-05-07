require 'spec_helper'

describe ConfigCurator::Symlink do

  subject(:symlink) { ConfigCurator::Symlink.new }

  describe "#install" do

    it "makes a symbolic link" do
      allow(File).to receive(:exists?).and_return(true)
      symlink.source = 'file'
      symlink.destination = 'link'
      expect(symlink).to receive(:install_symlink)
      symlink.install
    end
  end

  describe "#install?" do

    context "when source not given" do

      it "fails" do
        symlink.destination = 'link_path'
        expect { symlink.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
      end
    end

    context "when destination not given" do

      it "fails" do
        symlink.source = 'file'
        expect { symlink.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
      end
    end

    context "when source does not exist" do

      it "fails" do
        symlink.destination = 'link_path'
        symlink.source = 'path/that/does/not/exist'
        expect { symlink.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
      end
    end
  end
end
