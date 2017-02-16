namespace :test do
  namespace :appsule do
    Dir[File.join(Appsules.test_path, '*')].each do |appsule_path|
      appsule_name = appsule_path.split("/").last
      Rake::Task[:test].enhance { Rake::Task["test:appsule:#{appsule_name}"].invoke }
      desc "run tests for appsule #{appsule_name}"
      Rails::TestTask.new(appsule_name => "test:prepare") do |t|
        t.pattern = File.join(appsule_path, '**', '*_test.rb')
      end
    end
  end
end
