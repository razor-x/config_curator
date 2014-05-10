require 'logger'
require 'socket'

module ConfigCurator

  # A unit is the base class for a type of configuration
  # that should be installed.
  # All units must specify a {#source} and a {#destination}.
  class Unit

    # Error if the unit will fail to install.
    class InstallFailed < RuntimeError; end

    attr_accessor :logger, :source, :destination, :hosts, :packages

    # Default {#options}.
    DEFAULT_OPTIONS = {
      # Unit installed relative to this path.
      root: Dir.home,

      # Package tool to use. See #package_lookup.
      package_tool: nil,
    }

    def initialize options: {}, logger: nil
      self.options options
      self.logger = logger unless logger.nil?
    end

    # Uses {DEFAULT_OPTIONS} as initial value.
    # @param options [Hash] merged with current options
    # @return [Hash] current options
    def options options = {}
      @options ||= DEFAULT_OPTIONS
      @options = @options.merge options
    end

    # Logger instance to use.
    # @return [Logger] logger instance
    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = self.class.name
      end
    end

    # Full path to source.
    # @return [String] expanded path to source
    def source_path
      File.expand_path source unless source.nil?
    end

    # Full path to destination.
    # @return [String] expanded path to destination
    def destination_path
      File.expand_path File.join(options[:root], destination) unless destination.nil?
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
      @package_lookup ||= PackageLookup.new tool: options[:package_tool]
    end

    # Installs the unit.
    def install
      return false unless install?
      true
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

    # Checks if command exists.
    # @param command [String] command name to check
    # @return [String, nil] full path to command or nil if not found
    def command? command
      MakeMakefile::Logging.instance_variable_set :@logfile, File::NULL
      MakeMakefile::Logging.quiet = true
      MakeMakefile.find_executable command.to_s
    end
  end

end
