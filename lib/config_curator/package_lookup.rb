module ConfigCurator

  class PackageLookup

    # Default list of supported package tools.
    TOOLS = %i(dpkg pacman)

    attr_accessor :tool, :tools

    def initialize tool: nil
      @tool = tool
    end

    # Package tools that support package lookup ordered by preference.
    # @return [Array] list of supported package tools
    def tools
      @tools ||= TOOLS
    end

    # The package tool to use for this instance.
    # @return [Symbol] tool to use
    def tool
      return @tool if @tool

      tools.each do |cmd|
        if command? cmd
          @tool = cmd
          return @tool
        end
      end
    end

    # Checks if package is installed.
    # @param package [String] package name to check
    # @return [Boolean] if package is installed
    def installed? package
      send tool, package
    end

    private

    # Checks if command exists.
    # @param command [String] command name to check
    # @return [Boolean] if command exists
    def command? command
      `which #{command}`
      $?.success?
    end

    #
    # Tool specific package lookup methods below.
    #

    def dpkg package
      Open3.popen3 'dpkg', '-s', package do |_, _ , _, wait_thr|
        wait_thr.value.to_i
      end
    end

    def pacman package
      Open3.popen3 'pacman', '-qQ', package do |_, _ , _, wait_thr|
        wait_thr.value.to_i
      end
    end
  end

end
