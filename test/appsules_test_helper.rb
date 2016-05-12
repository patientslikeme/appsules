$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'active_support'
ActiveSupport::TestCase.test_order = :random  # if we don't set this, active_support gives a warning
require 'minitest/autorun'

require 'appsules'
