require_relative 'appsules_test_helper'
require_relative '../lib/appsules/ruby_file'

class RubyFileTest < ActiveSupport::TestCase

  def ruby_file(fixture_name)
    filename = File.join(File.dirname(__FILE__), 'fixtures', fixture_name)
    Appsules::RubyFile.new(filename)
  end

  test "returns the helper name when the Ruby file defines a helper" do
    assert_equal ["OneHelper"], ruby_file('defines_one_helper.rb').defined_helpers
  end

  test "returns the names of all helpers when the Ruby file defines multiple helpers" do
    assert_equal ["DogHelper", "CatHelper", "Boston::WeatherHelper"],
                 ruby_file('defines_many_helpers.rb').defined_helpers
  end

  test "returns an empty array when the Ruby file defines no helpers" do
    assert_equal [], ruby_file('defines_no_helpers.rb').defined_helpers
  end

end
