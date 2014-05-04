module ConfigCurator

  class Unit

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
  end

end
