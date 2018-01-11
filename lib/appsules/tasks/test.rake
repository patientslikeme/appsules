require "rails/test_unit/runner"

namespace :test do
  namespace :appsule do
    Dir[File.join(Appsules.test_path, "*")].each do |appsule_path|
      appsule_name = appsule_path.split("/").last
      Rake::Task[:test].enhance { Rake::Task["test:appsule:#{appsule_name}"].invoke }

      desc "run tests for appsule #{appsule_name}"
      task appsule_name => "test:prepare" do
        pattern = File.join(appsule_path, "**", "*_test.rb")
        Rails::TestUnit::Runner.run(Dir.glob(pattern))
      end
    end
  end
end
