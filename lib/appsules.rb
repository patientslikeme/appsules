require 'rails'
require 'appsules/definition_parser'
require 'appsules/ruby_file'
require 'appsules/helper_loader'
require 'appsules/railtie'

module Appsules

  def self.add_factory_girl_paths!
    Dir[File.join(Appsules.test_path, '*')].each do |appsule_path|
      FactoryGirl.definition_file_paths << File.join(appsule_path, 'factories')
    end
  end

  def self.test_path
    return @@test_path if defined?(@@test_path)
    @@test_path = Rails.root.join('test', 'appsules')
    FileUtils::mkdir_p @@test_path
    @@test_path
  end

  def self.path
    return @@path if defined?(@@path)
    @@path = Rails.root.join('appsules')
    FileUtils::mkdir_p @@path
    @@path
  end

  # for internal use by the appsules gem
  def self.add_helpers(appsule_path, initializer_context)
    loader = HelperLoader.new(initializer_context)
    Dir[File.join(appsule_path, '**', '*_helper.rb')].each do |helper_path|
      loader.load_helpers_defined_in(helper_path)
    end
  end

end
