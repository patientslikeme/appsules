# coding: utf-8
require File.expand_path('../../../local_gem_config', __FILE__)
gem_name = File.basename(__FILE__).split(".").first


LocalGem::Specification.new(gem_name) do |spec|


  # Add gems that are needed in order to run this gem.
  #
  # It's a good practice to use pessimistic
  # version constraints.  For more info, see
  # http://guides.rubygems.org/patterns/#declaring-dependencies
  #
  spec.add_runtime_dependency "rails"
  spec.add_runtime_dependency "factory_girl_rails"


  # Add local gems that are needed in order to run this gem.
  # You must also add these directly to this gem's Gemfile.
  #
  # Because local gems are essentially unversioned, you do
  # not need to specify a version constraint.
  #
  # spec.add_runtime_dependency "some_gem"
  # ...


  # Add gems that are needed in order to modify this gem.
  #
  # share/local_gem_config.rb already specifies some
  # default development gems, so don't re-add those.
  #
  spec.add_development_dependency "activesupport", "~> 4.2"  # because we use ActiveSupport::TestCase


  # Add or override defaults (see share/local_gem_config.rb).
  #
  # spec.post_install_message = "Go give Paul a high-five!"
  # ...


end.spec
