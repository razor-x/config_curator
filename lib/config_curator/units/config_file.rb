module ConfigCurator
  # A config file is a file that should be copied.
  class ConfigFile < Unit
    attr_accessor :fmode, :owner, :group

    # Will use files of the form `filename.hostname.ext` if found.
    # (see Unit#source)
    def source
      path = super
      host_specific_file = search_for_host_specific_file path if path

      if host_specific_file
        return host_specific_file
      else
        return path
      end
    end

    # (see Unit#destination)
    # @note Use {Unit#source} by default.
    def destination
      super
      @destination ||= @source
    end

    # (see Unit#uninstall)
    def uninstall(*args)
      s = super(*args)
      return s unless s
      uninstall_file
      true
    end

    # (see Unit#install)
    def install
      s = super
      return s unless s
      install_file
      set_mode
      set_owner
      true
    end

    # (see Unit#install?)
    def install?
      s = super
      return s unless s
      fail InstallFailed, 'No file source path specified.' if source_path.nil?
      fail InstallFailed, "Source path does not exist: #{source}" unless File.exist? source_path
      true
    end

    private

    # Uninstalls the file by removing it.
    def uninstall_file
      FileUtils.remove_entry_secure destination_path if File.exist? destination_path
    end

    # Recursively creates the necessary directories and install the file.
    def install_file
      FileUtils.mkdir_p File.dirname(destination_path)
      FileUtils.copy source_path, destination_path, preserve: true
    end

    # Sets file mode.
    def set_mode
      FileUtils.chmod fmode, destination_path unless fmode.nil?
    end

    # Sets file owner and group.
    def set_owner
      FileUtils.chown owner, group, destination_path
    end

    private

    # Will look for files with the naming pattern `filename.hostname.ext`.
    # @param path [String] path to the non-host-specific file
    # rubocop:disable Metrics/MethodLength
    def search_for_host_specific_file(path)
      directory = File.dirname path
      filename = File.basename path
      extension = File.extname path
      basename = filename.chomp(extension)
      if Dir.exist? directory
        files = Dir.entries(directory)

        file = files.grep(/^#{filename}\.#{hostname.downcase}$/).first
        return File.join directory, file unless file.nil?

        extension.gsub!(/^\./, '\.')
        regex = /^#{basename}\.#{hostname.downcase}#{extension}$/
        file = files.grep(regex).first
        return File.join directory, file unless file.nil?
      end
      nil
    end
  end
end
