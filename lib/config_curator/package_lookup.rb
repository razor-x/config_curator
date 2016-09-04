require 'mkmf'
require 'open3'

module ConfigCurator
  # Lookup if a package is installed on the system.
  # See {TOOLS} for supported package tools.
  # If {#tool} is not explicitly set, it will try and choose one automatically.
  # @example Lookup a package
  #   PackageLookup.new.installed? 'ruby' #=> true
  # @example Lookup a package using `pacman`
  #   PackageLookup.new(tool: :pacman).installed? 'ruby' #=> true
  class PackageLookup
    include Utils

    # Error when a package lookup cannot be completed.
    class LookupFailed < RuntimeError; end

    # Default list of supported package tools.
    # @see #tools
    TOOLS = {
      dpkg: 'dpkg',
      pacman: 'pacman',
      pkgng: 'pkg',
      brew: 'brew'
    }

    attr_accessor :tool, :tools

    def initialize(tool: nil)
      self.tool = tool
    end

    # Package tools that support package lookup ordered by preference.
    # Each key is an identifier and each value is the command to check for.
    # @return [Hash] hash of supported package tools
    def tools
      @tools ||= TOOLS
    end

    # The package tool to use for this instance.
    # @return [Symbol] tool to use
    def tool
      return @tool if @tool

      tools.each do |k, v|
        next unless command? v
        return @tool = k
      end
      @tool
    end

    # Checks if package is installed.
    # @param package [String] package name to check
    # @return [Boolean] if package is installed
    def installed?(package)
      fail LookupFailed, 'No supported package tool found.' if tool.nil?

      cmd = tools[tool]
      fail LookupFailed, "Package tool '#{cmd}' not found." if command?(cmd).nil?

      send tool, package
    end

    private

    #
    # Tool specific package lookup methods below.
    #

    def dpkg(package)
      cmd = command? 'dpkg'
      Open3.popen3 cmd, '-s', package do |_, _, _, wait_thr|
        wait_thr.value.to_i == 0
      end
    end

    def pacman(package)
      cmd = command? 'pacman'
      Open3.popen3 cmd, '-qQ', package do |_, _, _, wait_thr|
        wait_thr.value.to_i == 0
      end
    end

    def pkgng(package)
      cmd = command? 'pkg'
      Open3.popen3 cmd, 'info', package do |_, _, _, wait_thr|
        wait_thr.value.to_i == 0
      end
    end

    def brew(package)
      cmd = command? 'brew'
      stdout = `${cmd} ls --versions ${package}`
      !stdout.empty?
    end
  end
end
