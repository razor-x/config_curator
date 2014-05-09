require 'mkmf'

module ConfigCurator

  class Component < Unit

    attr_accessor :fmode, :dmode, :owner, :group

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
      fail InstallFailed, "Source path does not exist: #{source}" unless Dir.exists? source_path
      true
    end

    private

    # Recursively creates the necessary directories and install the component.
    # Any files in the install directory not in the source directory are removed.
    # Use rsync if available.
    def install_component
      if command? 'rsync'
        FileUtils.mkdir_p destination_path
        cmd = [command?('rsync'), '-rt', '--del', "#{source_path}/", destination_path]
        logger.debug { "Running command: #{cmd.join ' '}" }
        system *cmd
      else
        FileUtils.remove_entry_secure destination_path
        FileUtils.mkdir_p destination_path
        FileUtils.cp_r "#{source_path}/.", destination_path, preserve: true
      end
    end

    # Recursively sets file mode.
    # @todo
    def set_mode
    end

    # Recursively sets file owner and group.
    # @todo
    def set_owner
    end

    # Checks if command exists.
    # @param command [String] command name to check
    # @return [String, nil] full path to command or nil if not found
    def command? command
      MakeMakefile::Logging.quiet = true
      MakeMakefile.find_executable command.to_s
    end
  end

end
