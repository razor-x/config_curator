module ConfigCurator

  class Symlink < Unit

    # @see Unit#install
    def install
      s = super
      return s unless s
      install_symlink
      true
    end

    # @see Unit#install?
    def install?
      s = super
      return s unless s
      fail InstallFailed, "No source file specified." if source_path.nil?
      fail InstallFailed, "No destination specified." if destination_path.nil?
      true
    end

    private

    # Recursively creates the necessary directories and make the symlink.
    def install_symlink
      FileUtils.mkdir_p File.dirname(destination_path)
      FileUtils.symlink source_path, destination_path, force: true
    end
  end

end
