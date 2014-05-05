module ConfigCurator

  class Collection

    attr_accessor :logger, :manifest

    def initialize manifest_path: nil, logger: nil
      self.logger = logger unless logger.nil?
      self.load_manifest manifest_path unless manifest_path.nil?
    end

    # Logger instance to use.
    # @return [Logger] logger instance
    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = self.class.name
      end
    end

    # Load the manifest from file.
    # @param file [Hash] the yaml file to load
    # @return [Hash] the loaded manifest
    def load_manifest file
      self.manifest = YAML.load_file file
    end
  end

end
