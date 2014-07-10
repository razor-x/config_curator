require 'logger'
require 'thor'

module ConfigCurator
  # Thor class for the `curate` command.
  class CLI < Thor
    default_task :install

    class_option :verbose, type: :boolean, aliases: %i(v)
    class_option :quiet, type: :boolean, aliases: %i(q)
    class_option :debug, type: :boolean

    # Installs the collection.
    # @param manifest [String] path to the manifest file to use
    # @return [Boolean] value of {Collection#install} or {Collection#install?}
    desc 'install', 'Installs all units in collection.'
    option :dryrun,
           type: :boolean, aliases: %i(n),
           desc: %q{Only simulate the install. Don't make any actual changes.}
    def install(manifest = 'manifest.yml')
      unless File.exist? manifest
        logger.fatal { "Manifest file '#{manifest}' does not exist." }
        return false
      end

      collection.load_manifest manifest
      result = options[:dryrun] ? collection.install? : collection.install

      msg = install_message(result, options[:dryrun])
      result ? logger.info(msg) : logger.error(msg)
      result
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
          log.level = log_level(options)
        end
      end
    end

    private

    def log_level(options)
      if options[:debug]
        Logger::DEBUG
      elsif options[:verbose]
        Logger::INFO
      elsif options[:quiet]
        Logger::FATAL
      else
        Logger::WARN
      end
    end

    def install_message(result, dryrun)
      "Install #{'simulation ' if dryrun}" + \
        if result
          'completed without error.'
        elsif result.nil?
          'failed.'
        else
          'failed. No changes were made.'
        end
    end
  end
end
