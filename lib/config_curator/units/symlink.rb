module ConfigCurator

  class Symlink < Unit

    attr_accessor :source, :destination

    # @see Unit#install
    def install
      super
      symlink
    end

    # @see Unit#install?
    def install?
      super
      fail InstallFailed, "No source file specified." if source_path.nil?
      fail InstallFailed, "No destination specified." if link_path.nil?
      fail InstallFailed, "Source file does not exist." unless File.exists? source_path
    end

    # Full path to source file.
    # @return [String] expanded path to source file
    def source_path
      File.expand_path source unless source.nil?
    end

    # Full path to new symlink.
    # @return [String] expanded path to symlink
    def link_path
      File.expand_path File.join(options[:root], destination) unless destination.nil?
    end

    private

    # Recursively create the necessary directories and make the symlink.
    def symlink
      FileUtils.mkdir_p File.dirname(link_path)
      FileUtils.symlink source_path, link_path, force: true
    end
  end

end
