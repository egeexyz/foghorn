# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Foghorn do
  # ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
  # LOG LEVELS
  # ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
  context 'when logging at each level' do
    # Parameterized: every level that should print at :normal
    %i[info success warn].each do |method|
      describe ".#{method}" do
        it 'prints the message to stdout' do
          expect { Foghorn.send(method, 'hello') }.to output(/hello/).to_stdout
        end

        it 'suppresses output in quiet mode' do
          Foghorn.level = :quiet
          expect { Foghorn.send(method, 'hello') }.not_to output.to_stdout
        end
      end
    end

    describe '.error' do
      it 'prints the message to stdout' do
        expect { Foghorn.error('fail') }.to output(/fail/).to_stdout
      end

      it 'always prints even in quiet mode' do
        Foghorn.level = :quiet
        expect { Foghorn.error('fail') }.to output(/fail/).to_stdout
      end
    end

    describe '.debug' do
      it 'prints when level is :debug' do
        Foghorn.level = :debug
        expect { Foghorn.debug('trace') }.to output(/trace/).to_stdout
      end

      it 'suppresses output at :normal level' do
        expect { Foghorn.debug('trace') }.not_to output.to_stdout
      end
    end

    describe '.verbose' do
      it 'prints when level is :verbose' do
        Foghorn.level = :verbose
        expect { Foghorn.verbose('detail') }.to output(/detail/).to_stdout
      end

      it 'prints when level is :debug' do
        Foghorn.level = :debug
        expect { Foghorn.verbose('detail') }.to output(/detail/).to_stdout
      end

      it 'suppresses output at :normal level' do
        expect { Foghorn.verbose('detail') }.not_to output.to_stdout
      end
    end
  end

  # ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
  # FILE LOGGING
  # ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
  context 'with file logging enabled' do
    describe '.enable_file_logging' do
      it 'creates a log file in the specified directory' do
        Dir.mktmpdir do |dir|
          expect { Foghorn.enable_file_logging('test', log_dir: dir) }.to output(/Logging to/).to_stdout

          log_files = Dir.glob(File.join(dir, 'test-*.log'))
          expect(log_files.size).to eq(1)

          Foghorn.close_log
        end
      end

      it 'writes messages to the log file without color codes' do
        Dir.mktmpdir do |dir|
          expect { Foghorn.enable_file_logging('test', log_dir: dir) }.to output.to_stdout
          expect { Foghorn.success('deployed') }.to output.to_stdout
          expect { Foghorn.error('broken') }.to output.to_stdout

          Foghorn.close_log

          log_content = File.read(Dir.glob(File.join(dir, 'test-*.log')).first)
          expect(log_content).to include('deployed')
          expect(log_content).to include('[ERROR] broken')
          expect(log_content).not_to match(/\e\[/)
        end
      end
    end

    describe '.close_log' do
      it 'stops writing to the log file' do
        Dir.mktmpdir do |dir|
          expect { Foghorn.enable_file_logging('test', log_dir: dir) }.to output.to_stdout
          Foghorn.close_log

          expect { Foghorn.info('after close') }.to output.to_stdout

          log_content = File.read(Dir.glob(File.join(dir, 'test-*.log')).first)
          expect(log_content).not_to include('after close')
        end
      end
    end
  end
end
