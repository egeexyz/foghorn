# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'foghorn'
  spec.version       = File.read(File.join(__dir__, 'VERSION')).strip
  spec.authors       = ['egee']
  spec.email         = ['egee@egee.io']

  spec.summary       = 'A readable, terminal-friendly logger for Ruby CLIs'
  spec.description   = 'Foghorn provides colored console output with optional dual-write to a ' \
                       'plain-text log file. Built for CLI tools that need beautiful terminal ' \
                       'output and persistent logs without the complexity of enterprise logging.'
  spec.homepage      = 'https://gitlab.com/egeexyz/foghorn'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.0'

  spec.files         = Dir['lib/**/*.rb', 'VERSION', 'LICENSE', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'rainbow', '~> 3.1'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['changelog_uri']         = "#{spec.homepage}/-/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'
end
