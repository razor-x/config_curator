require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'logger'
require 'yaml'

module ConfigCurator
  # Manages collections of units.
  # @example Load a list of units and install them
  #  Collection.new(manifest_path: 'manifest.yml').install
  class Collection
    # Supported unit types.
    UNIT_TYPES = %i(unit component config_file symlink)

    # The possible attributes specific to each unit type.
    # This should not include generic attributes
    # such as {Unit#source} and {Unit#destination}.
    UNIT_ATTRIBUTES = {
      unit: %i(hosts packages),
      component: %i(hosts packages fmode dmode owner group backend),
      config_file: %i(hosts packages fmode owner group),
      symlink: %i(hosts packages)
    }

    attr_accessor :logger, :manifest, :units

    def initialize(manifest_path: nil, logger: nil)
      self.logger = logger unless logger.nil?
      load_manifest manifest_path unless manifest_path.nil?
    end

    # Logger instance to use.
    # @return [Logger] logger instance
    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = self.class.name
      end
    end

    # Loads the manifest from file.
    # @param file [Hash] the yaml file to load
    # @return [Hash] the loaded manifest
    def load_manifest(file)
      self.manifest =
        ActiveSupport::HashWithIndifferentAccess.new YAML.load_file(file)
    end

    # Unit objects defined by the manifest and organized by type.
    # @return [Hash] keys are pluralized unit types from {UNIT_TYPES}
    def units
      @units ||= {}.tap do |u|
        UNIT_TYPES.each do |type|
          k = type.to_s.pluralize.to_sym
          u[k] = []

          next unless manifest
          next if manifest[k].nil?

          manifest[k].each { |v| u[k] << create_unit(type, attributes: v) }
        end
      end
    end

    # Installs all units from the manifest.
    # @return [Boolean, nil] if units were installed or nil if fails mid-install
    def install
      return false unless install? quiet: !(logger.level == Logger::DEBUG)

      UNIT_TYPES.each do |type|
        units[type.to_s.pluralize.to_sym].each do |unit|
          return nil unless install_unit(unit, type)
        end
      end
      true
    end

    # Checks all units in the manifest for any detectable install issues.
    # @param quiet [Boolean] suppress some {#logger} output
    # @return [Boolean] if units can be installed
    def install?(quiet: false)
      result = true
      UNIT_TYPES.each do |type|
        units[type.to_s.pluralize.to_sym].each do |unit|
          result = install_unit?(unit, type, quiet) ? result : false
        end
      end
      result
    end

    # Creates a new unit object for the collection.
    # @param type [Symbol] a unit type in {UNIT_TYPES}
    # @param attributes [Hash] attributes for the unit from {UNIT_ATTRIBUTES}
    # @return [Unit] the unit object of the appropriate subclass
    def create_unit(type, attributes: {})
      "#{self.class.name.split('::').first}::#{type.to_s.camelize}".constantize
        .new(options: unit_options, logger: logger).tap do |unit|
        {src: :source, dst: :destination}.each do |k, v|
          unit.send "#{v}=".to_sym, attributes[k] unless attributes[k].nil?
        end

        UNIT_ATTRIBUTES[type].each do |v|
          unit.send "#{v}=".to_sym, defaults[v] unless defaults[v].nil?
          unit.send "#{v}=".to_sym, attributes[v] unless attributes[v].nil?
        end
      end
    end

    private

    # Formats a unit type for display.
    # @param type [Symbol] the unit type
    # @return [String] formatted unit type
    def type_name(type)
      type.to_s.humanize capitalize: false
    end

    # Hash of any defaults given in the manifest.
    # @return [Hash] the defaults
    def defaults
      return {} unless manifest
      manifest[:defaults].nil? ? {} : manifest[:defaults]
    end

    # Load basic unit options from the manifest.
    # @return [Hash] the options
    def unit_options
      options = {}
      return options unless manifest
      %i(root package_tool).each do |k|
        options[k] = manifest[k] unless manifest[k].nil?
      end
      options
    end

    # Installs a unit.
    # @param unit [Unit] the unit to install
    # @param type [Symbol] the unit type
    # @param quiet [Boolean] suppress some {#logger} output
    # @return [Boolean] if unit was installed
    def install_unit(unit, type, quiet = false)
      success = unit.install
      logger.info do
        "Installed #{type_name(type)}: #{unit.source} ⇨ #{unit.destination_path}"
      end unless quiet || !success
      return true

    rescue Unit::InstallFailed => e
      logger.fatal { "Halting install! Install attempt failed for #{type_name(type)}: #{e}" }
      return false
    end

    # Checks if a unit can be installed.
    # @param unit [Unit] the unit to check
    # @param type [Symbol] the unit type
    # @param quiet [Boolean] suppress some {#logger} output
    # @return [Boolean] if unit can be installed
    def install_unit?(unit, type, quiet = false)
      unit.install?
      logger.info do
        "Testing install for #{type_name(type)}:" \
        " #{unit.source} ⇨ #{unit.destination_path}"
      end unless quiet
      return true

    rescue Unit::InstallFailed => e
      logger.error { "Cannot install #{type_name(type)}: #{e}" }
      return false
    end
  end
end
