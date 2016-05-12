module Appsules
  class Railtie < Rails::Railtie
    rake_tasks do
       Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
    initializer 'appsules.autoload', :before => :set_autoload_paths do |app|
      Dir[File.join(Appsules.path, '*')].each do |appsule_path|
        app.config.paths.add appsule_path, eager_load: true, glob: "*"
      end
    end
    initializer "appsules.autoload_views" do |app|
      ActiveSupport.on_load :action_controller do
        Dir[File.join(Appsules.path, '*')].each do |appsule_path|
          append_view_path File.join(appsule_path, 'views')
        end
      end
    end
  end
end
