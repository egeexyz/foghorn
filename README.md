# 🌫️ Foghorn

A readable, terminal-friendly logger for Ruby CLIs.

Foghorn provides you with colored console output with optional dual-write to a plain-text log file. No monkey-patching, no enterprise bloat — just clear signals through the noise.

## Installation

Add to your Gemfile:

```ruby
gem 'foghorn'
```

## Usage

```ruby
require 'foghorn'

Foghorn.info "Deploying to production..."
Foghorn.success "All services healthy"
Foghorn.warn "Memory at 72%"
Foghorn.error "Connection refused"
Foghorn.debug "Checking state..."    # only shown at debug level
Foghorn.verbose "Detailed output..."  # shown at verbose or debug level
```

### Log Levels

```ruby
Foghorn.level = :quiet   # errors only
Foghorn.level = :normal  # info, success, warn, error (default)
Foghorn.level = :verbose # adds verbose messages
Foghorn.level = :debug   # adds debug messages
```

### File Logging

Dual-write to terminal (with color) and a plain-text log file (without color):

```ruby
Foghorn.enable_file_logging('production')
# => Creates ./logs/production-20260218-183000.log

# Custom log directory
Foghorn.enable_file_logging('myapp', log_dir: '/var/log/myapp')

# Close when done
Foghorn.close_log
```

## Development

```bash
bundle install
rake test     # lint + specs
rake build    # build the gem
rake release  # lint, test, bump, tag
```

## License

MIT
