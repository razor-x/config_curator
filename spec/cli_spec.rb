require 'spec_helper'

describe ConfigCurator::CLI do
  subject(:cli) { ConfigCurator::CLI.new }

  describe "#collection" do
    it "makes a new collection" do
      expect(cli.collection).to be_a ConfigCurator::Collection
    end

    it "sets the logger for the collection" do
      expect(cli.collection.logger).to be cli.logger
    end
  end

  describe "#logger" do
    it "makes a new logger" do
      expect(cli.logger).to be_a Logger
    end
  end

  describe "#install" do
    it "installs the collection" do
      allow(File).to receive(:exist?).with('manifest.yml').and_return(true)
      expect(cli.collection).to receive(:load_manifest).with('manifest.yml')
      expect(cli.collection).to receive(:install).and_return(true)
      expect(cli.install 'manifest.yml').to be true
    end

    context "when --dryrun is set" do
      before(:each) { allow(cli).to receive(:options).and_return(dryrun: true) }

      it "only checks if install would succeed" do
        allow(File).to receive(:exist?).with('manifest.yml').and_return(true)
        expect(cli.collection).to receive(:load_manifest).with('manifest.yml')
        expect(cli.collection).to receive(:install?).and_return(true)
        expect(cli.collection).to_not receive(:install)
        expect(cli.install 'manifest.yml').to be true
      end
    end

    context "manifest not found" do
      it "returns false and doesn't do anything else" do
        allow(File).to receive(:exist?).with('manifest.yml').and_return(false)
        expect(cli.collection).to_not receive(:install)
        expect(cli.collection).to_not receive(:install?)
        expect(cli.install 'manifest.yml').to be false
      end

      context "when --dryrun is set" do
        before(:each) { allow(cli).to receive(:options).and_return(dryrun: true) }

        it "returns false and doesn't do anything else" do
          allow(File).to receive(:exist?).with('manifest.yml').and_return(false)
          expect(cli.collection).to_not receive(:install)
          expect(cli.collection).to_not receive(:install?)
          expect(cli.install 'manifest.yml').to be false
        end
      end
    end
  end
end
