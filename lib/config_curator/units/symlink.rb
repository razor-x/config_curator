module ConfigCurator
  # A symlink is a symbolic link that should be created.
  # The {#destination_path} will be a link
  # that points to the {#source_path}.
  class Symlink < Unit
    # (see Unit#uninstall)
    def uninstall(*args)
      s = super(*args)
      return s unless s
      uninstall_symlink
      true
    end

    # (see Unit#install)
    def install
      s = super
      return s unless s
      install_symlink
      true
    end

    # (see Unit#install?)
    def install?
      s = super
      return s unless s
      fail InstallFailed, 'No source file specified.' if source_path.nil?
      fail InstallFailed, 'No destination specified.' if destination_path.nil?
      true
    end

    private

    # Uninstalls the symlink by removing it.
    def uninstall_symlink
      FileUtils.remove_entry_secure destination_path if File.exist? destination_path
    end

    # Recursively creates the necessary directories and make the symlink.
    def install_symlink
      FileUtils.mkdir_p File.dirname(destination_path)
      FileUtils.symlink source_path, destination_path, force: true
    end
  end
end
