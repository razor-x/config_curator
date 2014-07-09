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
    UNIT_ATTRIBUTESS = {
      unit: %i(hosts packages),
      component: %i(hosts packages fmode dmode owner group),
      config_file: %i(hosts packages fmode owner group),
      symlink: %i(hosts packages),
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
      self.manifest = YAML.load_file file
    end

    # Unit objects defined by the manifest and organized by type.
    # @return [Hash] keys are pluralized unit types from {UNIT_TYPES}
    def units
      @units ||= {}.tap do |u|
        UNIT_TYPES.each do |type|
          k = type.to_s.pluralize.to_sym
          u[k] = []

          if manifest
            manifest[k].each do |v|
              u[k] << create_unit(type, attributes: v)
            end unless manifest[k].nil?
          end
        end
      end
    end

    # Installs all units from the manifest.
    # @return [Boolean, nil] if units were installed or nil when fails mid-install
    def install
      return false unless install? quiet: !(logger.level == Logger::DEBUG)

      UNIT_TYPES.each do |t|
        type_name = t.to_s.humanize capitalize: false

        units[t.to_s.pluralize.to_sym].each do |unit|
          begin
            if unit.install
              logger.info { "Installed #{type_name}: #{unit.source} ⇨ #{unit.destination_path}" }
            end
          rescue Unit::InstallFailed => e
            logger.fatal { "Halting install! Install attempt failed for #{type_name}: #{e}" }
            return nil
          end
        end
      end
      true
    end

    # Checks all units in the manifest for any detectable install issues.
    # @param quiet [Boolean] suppress some {#logger} output
    # @return [Boolean] if units can be installed
    def install?(quiet: false)
      result = true
      UNIT_TYPES.each do |t|
        type_name = t.to_s.humanize capitalize: false

        units[t.to_s.pluralize.to_sym].each do |unit|
          begin
            if unit.install?
              logger.info { "Testing install for #{type_name}: #{unit.source} ⇨ #{unit.destination_path}" }
            end unless quiet
          rescue Unit::InstallFailed => e
            result = false
            logger.error { "Cannot install #{type_name}: #{e}" }
          end
        end
      end
      result
    end

    # Creates a new unit object for the collection.
    # @param type [Symbol] a unit type in {UNIT_TYPES}
    # @param attributes [Hash] attributes for the unit from {UNIT_ATTRIBUTESS}
    # @return [Unit] the unit object of the appropriate subclass
    def create_unit(type, attributes: {})
      options = {}
      %i(root package_tool).each do |k|
        options[k] = manifest[k] unless manifest[k].nil?
      end if manifest

      "#{self.class.name.split('::').first}::#{type.to_s.camelize}".constantize
      .new(options: options, logger: logger).tap do |unit|
        {src: :source, dst: :destination}.each do |k, v|
          unit.send "#{v}=".to_sym, attributes[k] unless attributes[k].nil?
        end

        UNIT_ATTRIBUTESS[type].each do |v|
          unit.send "#{v}=".to_sym, defaults[v] unless defaults[v].nil?
          unit.send "#{v}=".to_sym, attributes[v] unless attributes[v].nil?
        end
      end
    end

    private

    # Hash of any defaults given in the manifest.
    def defaults
      return {} unless manifest
      manifest[:defaults].nil? ? {} : manifest[:defaults]
    end
  end
end
