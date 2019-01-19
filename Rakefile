

# require 'rake/testtask'
# Rake::TestTask.new do |t|
#     t.libs << "lib"
#     t.test_files = FileList['spec/**/*_spec.rb']
#     t.verbose = true
# end

# to run all test, 'rake test'
# to run all one, rake test TEST=spec/graphic_spec

# rake test                           # run tests normally
# rake test TEST=just_one_file.rb     # run just one test file.
# rake test TESTOPTS="-v"             # run in verbose mode
# rake test TESTOPTS="--runner=fox"   # use the fox test runner



# put above code in rlayout.rb

# desc 'run all test specs'
task :test_all do
  Dir.glob(File.join(File.dirname(__FILE__), 'spec/**/*_spec.rb')).each do |file|
   puts  "ruby #{file}"
  #  system("ruby #{file}")
  end
end

desc 'list all test specs'
task :list_all do
  Dir.glob(File.join(File.dirname(__FILE__), 'spec/**/*_spec.rb')).each do |file|
   puts file
  end
end
