# frozen_string_literal: true

require 'foghorn'
require 'stringio'
require 'tmpdir'

RSpec.configure do |config|
  config.before do
    Foghorn.level = :normal
    Foghorn.close_log
  end
end
