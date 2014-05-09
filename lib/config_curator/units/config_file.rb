module ConfigCurator

  class ConfigFile < Unit

    attr_accessor :fmode, :owner, :group

    # Will use files of the form `filename.hostname.ext` if found.
    # @see Unit#source
    def source
      path = super
      host_specific_file = search_for_host_specific_file path if path
      if host_specific_file then return host_specific_file else return path end
    end

    # Use {#source} by default.
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
      fail InstallFailed, "Source path does not exist: #{source}" unless File.exists? source_path
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

    private

    # Will look for files with the naming pattern `filename.hostname.ext`.
    # @param path [String] path to the non-host-specific file
    def search_for_host_specific_file path
      directory = File.dirname path
      extension = File.extname path
      basename = File.basename path.chomp(extension)
      if Dir.exists? directory
        Dir.entries(directory).grep(/^#{basename}.#{hostname.downcase}/).first
      else
        nil
      end
    end
  end

end
