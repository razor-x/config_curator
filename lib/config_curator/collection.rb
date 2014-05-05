module ConfigCurator

  class Collection

    attr_accessor :logger

    def initialize logger: nil
      self.logger = logger unless logger.nil?
    end

    # Logger instance to use.
    # @return [Logger] logger instance
    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = self.class.name
      end
    end
  end

end
