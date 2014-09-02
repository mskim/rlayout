require "bundler/gem_tasks"

@spec_foler = File.dirname(__FILE__) + "/spec"

task :test_all do
  Dir.glob("#{@spec_foler}/*_spec.rb") do |test|
    system("ruby #{test}")
  end
end