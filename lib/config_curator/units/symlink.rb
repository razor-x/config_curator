module ConfigCurator

  class Symlink < Unit

    # @see Unit#install
    def install
      super
      install_symlink
    end

    # @see Unit#install?
    def install?
      super
      fail InstallFailed, "No source file specified." if source_path.nil?
      fail InstallFailed, "No destination specified." if destination_path.nil?
      fail InstallFailed, "Source file does not exist: #{source}" unless File.exists? source_path
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
