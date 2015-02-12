# if RUBY_ENGINE == "rubymotion"
#   puts "rubymotion "
  unless defined?(Motion::Project::Config)
    raise "This file must be required within a RubyMotion project Rakefile."
  end

  Motion::Project::App.setup do |app|
    Dir.glob(File.join(File.dirname(__FILE__), 'rlayout/**/*.rb')).each do |file|
      puts "files included:#{file}"
      app.files.unshift(file)
    end
  end
# else
#   if  RUBY_ENGINE == 'macruby'
#     puts "MacRuby"
#   # elsif RUBY_ENGINE == 'ruby' 
#     require File.dirname(__FILE__) + "/rlayout/version"
#     require File.dirname(__FILE__) + "/rlayout/utility"
#     require File.dirname(__FILE__) + "/rlayout/graphic"
#     require File.dirname(__FILE__) + "/rlayout/container"
#     require File.dirname(__FILE__) + "/rlayout/object_box"
#     require File.dirname(__FILE__) + "/rlayout/text_column"
#     require File.dirname(__FILE__) + "/rlayout/text_box"
#     require File.dirname(__FILE__) + "/rlayout/text"
#     require File.dirname(__FILE__) + "/rlayout/page"
#     require File.dirname(__FILE__) + "/rlayout/page_variables_extend"
#     require File.dirname(__FILE__) + "/rlayout/document_variables_extend"
#     require File.dirname(__FILE__) + "/rlayout/view"
#     require File.dirname(__FILE__) + "/rlayout/document"
#     require File.dirname(__FILE__) + "/rlayout/article"
#     require File.dirname(__FILE__) + "/rlayout/publication/newspaper"
#     require File.dirname(__FILE__) + "/rlayout/publication/photo_book"
#   end
# end
# 
# module RLayout
#   # Your code goes here...
# end
