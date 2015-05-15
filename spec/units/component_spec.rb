require 'spec_helper'

describe ConfigCurator::Component do
  subject(:component) { ConfigCurator::Component.new }

  describe "#uninstall" do
    context "when component should be uninstalled" do
      it "uninstalls the component and returns true" do
        expect(component).to receive(:uninstall?).and_return(true)
        expect(component).to receive(:uninstall_component)
        expect(component.uninstall).to be true
      end
    end

    context "when component should not be uninstalled" do
      it "does not uninstall the component and returns false" do
        expect(component).to receive(:uninstall?).and_return(false)
        expect(component).to_not receive(:uninstall_component)
        expect(component.uninstall).to be false
      end
    end
  end

  describe "#install" do
    context "when component should be installed" do
      it "installs the component and returns true" do
        expect(component).to receive(:install?).and_return(true)
        expect(component).to receive(:install_component)
        expect(component).to receive(:set_mode)
        expect(component).to receive(:set_owner)
        expect(component.install).to be true
      end
    end

    context "when component should not be installed" do
      it "does not install the component and returns false" do
        expect(component).to receive(:install?).and_return(false)
        expect(component).to_not receive(:install_component)
        expect(component).to_not receive(:set_mode)
        expect(component).to_not receive(:set_owner)
        expect(component.install).to be false
      end
    end
  end

  describe "#install?" do
    context "when source not given" do
      it "fails" do
        component.destination = 'inst_path'
        expect { component.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
      end
    end

    context "when destination not given" do
      it "fails" do
        component.source = 'dir'
        expect { component.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
      end
    end

    context "when source does not exist" do
      it "fails" do
        component.destination = 'inst_path'
        component.source = 'dir/that/does/not/exist'
        expect { component.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
      end
    end
  end
end
