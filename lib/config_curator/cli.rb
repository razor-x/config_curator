require 'thor'

module ConfigCurator

  class CLI < Thor

    no_commands do

      # Makes a collection object to use for the instance.
      # @return [Collection] the collection object
      def collection
        @collection ||= Collection.new logger: logger
      end

      # Logger instance to use.
      # @return [Logger] logger instance
      def logger
        @logger ||= Logger.new($stdout).tap do |log|
          log.progname = 'curate'
          log.formatter = proc do |severity, _, _, msg|
            "#{severity} -- #{msg}\n"
          end
        end
      end
    end
  end

end
