require 'spec_helper'

describe ConfigCurator::Component do

  subject(:component) { ConfigCurator::Component.new }

  describe "#install" do

    it "installs the component" do
      allow(Dir).to receive(:exists?).and_return(true)
      component.source = 'file'
      component.destination = 'install_path'
      expect(component).to receive(:install_component)
      expect(component).to receive(:set_mode)
      expect(component).to receive(:set_owner)
      component.install
    end
  end

  describe "#install?" do

    it "fails when source not given" do
      component.destination = 'inst_path'
      expect { component.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
    end

    it "fails when destination not given" do
      component.source = 'dir'
      expect { component.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
    end

    it "fails when source does not exist" do
      component.destination = 'inst_path'
      component.source = 'dir/that/does/not/exist'
      expect { component.install? }.to raise_error ConfigCurator::Symlink::InstallFailed
    end
  end
end
