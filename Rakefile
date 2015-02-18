
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  app.name = 'rlayout'
  app.frameworks << 'AppKit'
  Dir.glob(File.join(File.dirname(__FILE__), 'lib/**/*.rb')).each do |file|
    app.files.unshift(file)
  end
end
 
task :random_task do
  puts "Hello Random Task!"
end
