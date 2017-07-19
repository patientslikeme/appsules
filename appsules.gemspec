# coding: utf-8
require File.expand_path('../../../local_gem_config', __FILE__)
gem_name = File.basename(__FILE__).split(".").first

LocalGem::Specification.new(gem_name) do |spec|
  spec.add_runtime_dependency "rails", ">= 4.2", "< 6.0"
  spec.add_runtime_dependency "factory_girl_rails"
end.spec
