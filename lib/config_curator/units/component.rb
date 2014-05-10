require 'mkmf'

module ConfigCurator

  class Component < Unit

    attr_accessor :fmode, :dmode, :owner, :group

    # (see Unit#install)
    def install
      s = super
      return s unless s
      install_component
      set_mode
      set_owner
      true
    end

    # (see Unit#install?)
    def install?
      s = super
      return s unless s
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
    # @todo Make this more platform independent.
    def set_mode
      chmod = command? 'chmod'
      find = command? 'find'
      if chmod && find
        {fmode: 'f', dmode: 'd'}.each do |k, v|
          next if self.send(k).nil?
          cmd = [find,  destination_path, '-type', v, '-exec']
          cmd.concat [chmod, self.send(k).to_s(8), '{}', '+']
          logger.debug { "Running command: #{cmd.join ' '}" }
          system *cmd
        end
      end
    end

    # Recursively sets file owner and group.
    # @todo Make this more platform independent.
    def set_owner
      return unless owner || group
      chown = command? 'chown'
      if chown
        cmd = [chown, '-R', "#{owner}:#{group}", destination_path]
        logger.debug { "Running command: #{cmd.join ' '}" }
        system *cmd
      end
    end
  end

end
