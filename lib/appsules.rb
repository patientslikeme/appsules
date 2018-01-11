require "rails"
require "active_support"
require "active_support/core_ext"
require "appsules/railtie"

module Appsules
  def self.add_factory_bot_paths!
    Dir[File.join(Appsules.test_path, "*")].each do |appsule_path|
      FactoryBot.definition_file_paths << File.join(appsule_path, "factories")
    end
  end

  def self.add_factory_girl_paths!
    Dir[File.join(Appsules.test_path, "*")].each do |appsule_path|
      FactoryGirl.definition_file_paths << File.join(appsule_path, "factories")
    end
  end

  def self.test_path
    return @@test_path if defined?(@@test_path)
    @@test_path = Rails.root.join("test", "appsules")
    FileUtils.mkdir_p @@test_path
    @@test_path
  end

  def self.path
    return @@path if defined?(@@path)
    @@path = Rails.root.join("appsules")
    FileUtils.mkdir_p @@path
    @@path
  end

  # for internal use by the appsules gem
  def self.add_helpers(appsule_path, initializer_context)
    return unless initializer_context.respond_to?(:helper)

    helpers_dir = File.join(appsule_path, "helpers")

    Dir[File.join(helpers_dir, "**", "*_helper.rb")].map do |helper_path|
      module_name = helper_path.sub(%r{^#{helpers_dir}/(.+)\.rb}i, '\1').classify
      initializer_context.instance_eval "helper #{module_name}"
    end
  end
end
