require 'logger'
require 'thor'

module ConfigCurator

  class CLI < Thor

    # Installs the collection.
    # @param manifest [String] path to the manifest file to use
    # @return [Boolean] value of {Collection#install} or {Collection#install?}
    desc "install", "Installs all units in collection."
    option :dryrun, type: :boolean, aliases: %i(n),
      desc: %q{Only simulate the install. Don't make any actual changes.}
    def install manifest='manifest.yml'
      unless File.exists? manifest
        logger.fatal { "Manifest file '#{manifest}' does not exist." }
        return false
      end

      collection.load_manifest manifest
      result = options[:dryrun] ? collection.install? : collection.install

      msg = "Install #{'simulation ' if options[:dryrun]}" + \
        if result
          'completed without error.'
        else
          'failed.'
        end

      if result then logger.info msg else logger.error msg end
      return result
    end

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
