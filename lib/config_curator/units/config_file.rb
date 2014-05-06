module ConfigCurator

  class ConfigFile < Unit

    attr_accessor :fmode, :owner, :group

    # @see Unit#destination
    def destination
      super
      @destination ||= source
    end

    # @see Unit#install
    def install
      super
      install_file
      set_mode
      set_owner
    end

    # @see Unit#install?
    def install?
      super
      fail InstallFailed, "No file source path specified." if source_path.nil?
      fail InstallFailed, "Source path does not exist." unless File.exists? source_path
      true
    end

    private

    # Recursively creates the necessary directories and install the file.
    def install_file
      FileUtils.mkdir_p File.dirname(destination_path)
      FileUtils.copy source_path, destination_path
    end

    # Sets file mode.
    def set_mode
      FileUtils.chmod fmode, destination_path unless fmode.nil?
    end

    # Sets file owner and group.
    # @todo
    def set_owner
    end
  end

end
