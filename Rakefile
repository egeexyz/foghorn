# frozen_string_literal: true

require 'English'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:rspec) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = '--format documentation --color'
  end
rescue LoadError
  task :rspec do
    puts 'RSpec is not installed. Run: bundle install'
    exit 1
  end
end

desc 'Run all tests and linting'
task test: %i[lint rspec]
task spec: :test
task default: :test

# ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
# VERSION MANAGEMENT
# ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
VERSION_FILE = 'VERSION'

def current_version
  File.read(VERSION_FILE).strip
end

def write_version(version)
  File.write(VERSION_FILE, "#{version}\n")
end

desc 'Display current version'
task :version do
  puts "foghorn v#{current_version}"
end

desc 'Increment the patch version (1.0.0 -> 1.0.1)'
task :bump do
  major, minor, patch = current_version.split('.').map(&:to_i)
  new_version = "#{major}.#{minor}.#{patch + 1}"
  write_version(new_version)
  puts "Bumped version: #{current_version} -> #{new_version}"
end

namespace :bump do
  desc 'Increment the minor version (1.0.0 -> 1.1.0)'
  task :minor do
    major, minor, _patch = current_version.split('.').map(&:to_i)
    new_version = "#{major}.#{minor + 1}.0"
    write_version(new_version)
    puts "Bumped version: #{current_version} -> #{new_version}"
  end

  desc 'Increment the major version (1.0.0 -> 2.0.0)'
  task :major do
    major, _minor, _patch = current_version.split('.').map(&:to_i)
    new_version = "#{major + 1}.0.0"
    write_version(new_version)
    puts "Bumped version: #{current_version} -> #{new_version}"
  end
end

desc 'Release: lint, test, bump patch, and git tag'
task :release, [:level] => %i[lint test] do |_t, args|
  level = args[:level] || 'patch'
  old_version = current_version

  case level
  when 'major'
    Rake::Task['bump:major'].invoke
  when 'minor'
    Rake::Task['bump:minor'].invoke
  else
    Rake::Task['bump'].invoke
  end

  new_version = current_version
  puts "\nReleased: v#{old_version} -> v#{new_version}"
  puts "Run: git add VERSION && git commit -m 'Release v#{new_version}' && git tag v#{new_version}"
end

# ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
# LINTING
# ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
desc 'Lint Ruby files for syntax errors'
task :lint do # rubocop:disable Metrics/BlockLength
  errors = []

  puts 'Checking Ruby syntax...'
  ruby_files = Dir.glob('lib/**/*.rb') + Dir.glob('spec/**/*.rb')
  ruby_files.each do |file|
    output = `ruby -c #{file} 2>&1`
    if $CHILD_STATUS.success?
      puts "  ✓ #{file}"
    else
      errors << "Ruby syntax error in #{file}:\n#{output}"
    end
  end

  unless ENV['SKIP_RUBOCOP']
    puts "\nRunning RuboCop..."
    rubocop_result = system('bundle exec rubocop')
    errors << 'RuboCop found style violations' unless rubocop_result
  end

  puts "\n#{'≈' * 60}"
  if errors.any?
    puts 'LINT FAILURES'
    puts '≈' * 60
    errors.each { |e| puts "\n#{e}" }
    puts "\n#{'≈' * 60}"
    abort "Linting failed with #{errors.size} error(s)"
  else
    puts "✓ All files passed linting (#{ruby_files.size} Ruby)"
    puts '≈' * 60
  end
end

# ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
# BUILD
# ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
desc 'Build the gem'
task :build do
  system('gem build foghorn.gemspec')
end
