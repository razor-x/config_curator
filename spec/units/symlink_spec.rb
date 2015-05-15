require 'spec_helper'

describe ConfigCurator::Symlink do
  subject(:symlink) { ConfigCurator::Symlink.new }

  describe "#uninstall" do
    context "when symlink should be uninstalled" do
      it "uninstalls the symlink and returns true" do
        expect(symlink).to receive(:uninstall?).and_return(true)
        expect(symlink).to receive(:uninstall_symlink)
        expect(symlink.uninstall).to be true
      end
    end

    context "when symlink should not be uninstalled" do
      it "does not uninstall the symlink and returns false" do
        expect(symlink).to receive(:uninstall?).and_return(false)
        expect(symlink).to_not receive(:uninstall_symlink)
        expect(symlink.uninstall).to be false
      end
    end
  end

  describe "#install" do
    context "when symbolic link should be installed" do
      it "installs the symbolic link and returns true" do
        expect(symlink).to receive(:install?).and_return true
        expect(symlink).to receive(:install_symlink)
        expect(symlink.install).to be true
      end
    end

    context "when symbolic link should not be installed" do
      it "does not install the symbolic link and returns false" do
        expect(symlink).to receive(:install?).and_return false
        expect(symlink).to_not receive(:install_symlink)
        expect(symlink.install).to be false
      end
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
  end
end
