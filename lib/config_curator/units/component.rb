module ConfigCurator

  class Component < Unit

    attr_accessor :mode, :owner, :group

    # @see Unit#install
    def install
      super
      install_component
      set_mode
      set_owner
    end

    # @see Unit#install?
    def install?
      super
      fail InstallFailed, "No component source path specified." if source_path.nil?
      fail InstallFailed, "No component install path specified." if destination_path.nil?
      fail InstallFailed, "Source path does not exist." unless Dir.exists? source_path
      true
    end

    private

    # Recursively create the necessary directories and install the component.
    # Any files in the install directory not in the source directory are removed.
    # Use rsync if available.
    def install_component
      if command? 'rsync'
        FileUtils.mkdir_p destination_path
        system 'rsync', '-rt', '--del', "#{source_path}/", destination_path
      else
        FileUtils.remove_entry_secure destination_path
        FileUtils.mkdir_p destination_path
        FileUtils.cp_r "#{source_path}/.", destination_path
      end
    end

    # Recursively set file mode.
    # @todo
    def set_mode
    end

    # Recursively set file owner and group.
    # @todo
    def set_owner
    end
  end

end
