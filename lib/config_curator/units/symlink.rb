module ConfigCurator

  class Symlink < Unit

    # @see Unit#install
    def install
      super
      symlink
    end

    # @see Unit#install?
    def install?
      super
      fail InstallFailed, "No source file specified." if source_path.nil?
      fail InstallFailed, "No destination specified." if destination_path.nil?
      fail InstallFailed, "Source file does not exist." unless File.exists? source_path
      true
    end

    private

    # Recursively create the necessary directories and make the symlink.
    def symlink
      FileUtils.mkdir_p File.dirname(destination_path)
      FileUtils.symlink source_path, destination_path, force: true
    end
  end

end
