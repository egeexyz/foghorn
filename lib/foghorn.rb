# frozen_string_literal: true

require 'rainbow'
require 'fileutils'

# Foghorn — A readable, terminal-friendly logger for Ruby CLIs.
# Provides colored console output with optional dual-write to a plain-text log file.
module Foghorn
  VERSION = File.read(File.join(__dir__, '..', 'VERSION')).strip

  # Log levels (higher = more verbose)
  LEVELS = {
    quiet: 0,
    normal: 1,
    verbose: 2,
    debug: 3
  }.freeze

  @level = :normal
  @log_file = nil

  class << self
    attr_accessor :level

    # Enable file logging. Creates a timestamped log file.
    # All messages are written to both terminal (with color) and file (plain text).
    def enable_file_logging(label, log_dir: File.join(Dir.pwd, 'logs'))
      FileUtils.mkdir_p(log_dir)

      timestamp = Time.now.strftime('%Y%m%d-%H%M%S')
      log_path = File.join(log_dir, "#{label}-#{timestamp}.log")
      @log_file = File.open(log_path, 'a')
      @log_file.sync = true

      info("Logging to #{log_path}")
    end

    def close_log
      return unless @log_file

      @log_file.close
      @log_file = nil
    end

    def quiet?
      @level == :quiet
    end

    def verbose?
      @level == :verbose || @level == :debug
    end

    def debug?
      @level == :debug
    end

    def space
      return if quiet?

      puts ''
      log_to_file('')
    end

    def info(message)
      return if quiet?

      puts message
      log_to_file(message)
    end

    def success(message)
      return if quiet?

      puts Rainbow(message).green
      log_to_file(message)
    end

    def warn(message)
      return if quiet?

      puts Rainbow(message).yellow
      log_to_file("[WARN] #{message}")
    end

    def error(message)
      # Always show errors, even in quiet mode
      puts Rainbow(message).red
      log_to_file("[ERROR] #{message}")
    end

    def debug(message)
      return unless debug?

      puts Rainbow("[DEBUG] #{message}").darkgray
      log_to_file("[DEBUG] #{message}")
    end

    def verbose(message)
      return unless verbose?

      puts Rainbow(message).darkgray
      log_to_file(message)
    end

    private

    def log_to_file(message)
      return unless @log_file

      @log_file.puts("[#{Time.now.strftime('%H:%M:%S')}] #{message}")
    end
  end
end
