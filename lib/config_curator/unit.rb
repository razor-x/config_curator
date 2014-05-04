module ConfigCurator

  class Unit

    attr_accessor :hosts, :packages

    # Default {#options}.
    DEFAULT_OPTIONS = {
      # Unit installed relative to this path.
      root: Dir.home,
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
  end

end
