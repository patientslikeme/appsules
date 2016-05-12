require 'rails'
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

end
