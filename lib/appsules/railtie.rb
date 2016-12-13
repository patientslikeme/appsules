require 'pathname'

module Appsules
  class Railtie < Rails::Railtie
    rake_tasks do
       Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
       Dir[File.join(Appsules.path, '*', 'tasks/*.rake')].each { |f| load f }
    end

    # Add each appsule's immediate subdirectories as eager_load paths
    initializer 'appsules.autoload', :before => :set_autoload_paths do |app|
      Dir[File.join(Appsules.path, '*/*/')].each do |appsule_path|
        relative_path = Pathname.new(appsule_path).relative_path_from(Rails.root).to_s
        app.config.paths.add relative_path, eager_load: true
      end
    end

    initializer "appsules.autoload_views" do |app|
      ActiveSupport.on_load :action_controller do
        Dir[File.join(Appsules.path, '*')].each do |appsule_path|
          Appsules.add_helpers(appsule_path, self)
          append_view_path File.join(appsule_path, 'views')
        end
      end
    end

    # Add /test/appsules to $LOAD_PATH in the test environment
    initializer "appsules.tests_load_path" do |app|
      $LOAD_PATH << Appsules.test_path.to_s if Rails.env.test?
    end
  end
end
