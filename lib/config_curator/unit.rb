require 'socket'

module ConfigCurator

  class Unit

    # Error if the unit will fail to install.
    class InstallFailed < RuntimeError; end

    attr_accessor :hosts, :packages

    # Default {#options}.
    DEFAULT_OPTIONS = {
      # Unit installed relative to this path.
      root: Dir.home,

      # Package tool to use. See #package_lookup.
      package_tool: nil,
    }

    def initialize options: {}
      self.options options
    end

    # Uses {DEFAULT_OPTIONS} as initial value.
    # @param options [Hash] merged with current options
    # @return [Hash] current options
    def options options = {}
      @options ||= DEFAULT_OPTIONS
      @options = @options.merge options
    end

    # Unit will be installed on these hosts.
    # If empty, installed on any host.
    # @return [Array] list of hostnames
    def hosts
      @hosts ||= []
    end

    # Unit installed only if listed packages are installed.
    # @return [Array] list of package names
    def packages
      @packages ||= []
    end

    # A {PackageLookup} object for this unit.
    def package_lookup
      @package_lookup ||= ConfigCurator::PackageLookup.new tool: options[:package_tool]
    end

    # Install the unit.
    def install
      return unless install?
    end

    # Checks if the unit should be installed.
    # @return [Boolean] if the unit should be installed
    def install?
      return false unless allowed_host?
      return false unless packages_installed?
      true
    end

    # Checks if the unit should be installed on this host.
    # @return [Boolean] if the hostname is in {#hosts}
    def allowed_host?
      return true if hosts.empty?
      hosts.include? hostname
    end

    # Checks if the packages required for this unit are installed.
    # @return [Boolean] if the packages in {#packages} are installed
    def packages_installed?
      packages.map(&method(:pkg_exists?)).delete_if{ |e| e }.empty?
    end

    private

    # @return [String] the machine hostname
    def hostname
      Socket.gethostname
    end

    # @return [Boolean] if the package exists on the system
    def pkg_exists? pkg
      package_lookup.installed? pkg
    end
  end

end
