# unless defined?(Motion::Project::Config)
#   raise "This file must be required within a RubyMotion project Rakefile."
# end
# 
# Motion::Project::App.setup do |app|
#   Dir.glob(File.join(File.dirname(__FILE__), 'lib/**/*.rb')).each do |file|
#     app.files.unshift(file)
#   end
# end

# put above code in rlayout.rb

desc 'run all test specs'
task :test_all do
  Dir.glob(File.join(File.dirname(__FILE__), 'spec/**/*_spec.rb')).each do |file|
   puts  `macruby #{file}`
  end
end

desc 'list all test specs'
task :list_all do
  Dir.glob(File.join(File.dirname(__FILE__), 'spec/**/*_spec.rb')).each do |file|
   puts file
  end
end

