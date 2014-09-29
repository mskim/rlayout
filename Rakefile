# require "bundler/gem_tasks"
require 'rake/testtask'

# @spec_foler = File.dirname(__FILE__) + "/spec"

# task :test_all do
#   Dir.glob("#{@spec_foler}/*_spec.rb") do |test|
#     system("ruby #{test}")
#   end
# end
 
Rake::TestTask.new do |task|
  task.libs << %w(spec lib)
  task.pattern = 'spec/**/*_spec.rb'
end
 
desc "Run tests"
task :default => :test
