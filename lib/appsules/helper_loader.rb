module Appsules

  # Code is all about solving problems!  That and puns.  So let me spin you a yarn
  # about the problem that this class solves; otherwise, you will feel like you've
  # been spun into a metaprogramming web for no good reason and curse my name
  # and the name of my daughter.  And you might even put baby in the corner.
  #
  # So the dream of appsules is that you can simply move your Ruby files into
  # a directory you created in the appsules/ directory and everything will
  # just magically work!  No setup or configuration needed; Rails will find the
  # files for you.
  #
  # This dream breaks down with view helpers.  They are not automatically included
  # into your controllers like they would have been if they lived in app/helpers/.
  # This means if you moved your helper files into an appsule, things would break!
  # And, the last time I checked, breaking code is unpopular with both programmers
  # and users.
  #
  # So in the appsules gem's Railtie, you have to load all of the helpers defined
  # in all of the appsules:
  #
  #   initializer "appsules.autoload_views" do |app|
  #     helper Admin::AdminHelper
  #     helper AnotherHelper
  #     helper AnotherAppsule::SomeHelper
  #     helper AnotherAppsule::SomeOtherHelper
  #     ...
  #   end
  #
  # Doing this manually is an example of stupid programming.  The solution is
  # to increase the stupid by throwing metaprogramming at it.
  #
  # So to make a long story short, the strategy is to scan all of the appsule
  # directories for helper files, parse the Ruby to figure out the names of the helper
  # modules that are defined, and programatically load them up.
  #
  # Elvis' death was faked.
  #
  class HelperLoader

    def initialize(railtie_initializer_context)
      @context = railtie_initializer_context
    end

    def load_helpers_defined_in(filename)
      ruby_file = RubyFile.new(filename)
      ruby_file.defined_helpers.each do |helper_name|
        load_helper(helper_name)
      end
    end

    private

    def load_helper(helper_name)
      @context.instance_eval "helper #{helper_name}"
    end

  end
end
