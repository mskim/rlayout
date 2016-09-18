# if RUBY_ENGINE == 'rubymotion'
if defined?(Motion::Project::Config) 
  Motion::Project::App.setup do |app|
    Dir.glob(File.join(File.dirname(__FILE__), 'rlayout/**/*.rb')).each do |file|
      # excluded .rb files under experiment folder from compiling
      if file =~ /experiment/
        puts "excluded #{file}" 
        next
      end
      app.files.unshift(file)
    end
  end
  #
  # raise "This file must be required within a RubyMotion project Rakefile."

elsif RUBY_ENGINE == "opal"
  # require files for Opal
  #
else
  # puts RUBY_ENGINE
  # require 'pry'
  require 'strscan'
  require 'yaml'
  require 'csv'
  require 'erb'
  require 'base64'
    
  require "rlayout/version"
  require File.dirname(__FILE__) + '/rlayout/utility'
  require File.dirname(__FILE__) + '/rlayout/graphic/color'
  require File.dirname(__FILE__) + '/rlayout/graphic/graphic_struct'
  require File.dirname(__FILE__) + '/rlayout/graphic/fill'
  require File.dirname(__FILE__) + '/rlayout/graphic/image'
  require File.dirname(__FILE__) + '/rlayout/graphic/layout'
  require File.dirname(__FILE__) + '/rlayout/graphic/stroke'
  require File.dirname(__FILE__) + '/rlayout/graphic/shape'
  require File.dirname(__FILE__) + '/rlayout/graphic/rotation'
  require File.dirname(__FILE__) + '/rlayout/graphic/shadow'
  require File.dirname(__FILE__) + '/rlayout/graphic/node_tree'
  require File.dirname(__FILE__) + '/rlayout/graphic/text'
  require File.dirname(__FILE__) + '/rlayout/graphic'
  require File.dirname(__FILE__) + '/rlayout/view/graphic_view_svg'
  require File.dirname(__FILE__) + '/rlayout/container'
  require File.dirname(__FILE__) + '/rlayout/container/auto_layout'
  require File.dirname(__FILE__) + '/rlayout/container/grid'
  require File.dirname(__FILE__) + '/rlayout/container/pgscript'
  require File.dirname(__FILE__) + '/rlayout/container/text_form'
  require File.dirname(__FILE__) + '/rlayout/container/text_train'
  
  require File.dirname(__FILE__) + '/rlayout/text/heading'
  require File.dirname(__FILE__) + '/rlayout/text/paragraph_ns_text'
  require File.dirname(__FILE__) + '/rlayout/text/text_token'
  require File.dirname(__FILE__) + '/rlayout/text/paragraph'
  require File.dirname(__FILE__) + '/rlayout/text/text_layout_manager'
  require File.dirname(__FILE__) + '/rlayout/text/font'
  require File.dirname(__FILE__) + '/rlayout/text/text_train'
  require File.dirname(__FILE__) + '/rlayout/text/title_text'
  require File.dirname(__FILE__) + '/rlayout/text/ordered_list'

  require File.dirname(__FILE__) + '/rlayout/style/style_service'
  require File.dirname(__FILE__) + '/rlayout/style/grid_layout'
  require File.dirname(__FILE__) + '/rlayout/style/image_layout'
  
  require File.dirname(__FILE__) + '/rlayout/container/photo_item'
  require File.dirname(__FILE__) + '/rlayout/container/place_item'
  require File.dirname(__FILE__) + '/rlayout/container/memo_area'
  require File.dirname(__FILE__) + '/rlayout/container/grid'

  require File.dirname(__FILE__) + '/rlayout/box/box_ad_box'
  require File.dirname(__FILE__) + '/rlayout/box/image_box'
  require File.dirname(__FILE__) + '/rlayout/box/object_box'
  require File.dirname(__FILE__) + '/rlayout/box/text_column'
  require File.dirname(__FILE__) + '/rlayout/box/text_box'
  require File.dirname(__FILE__) + '/rlayout/box/grid_box'
  require File.dirname(__FILE__) + '/rlayout/box/composite_box'
  
  require File.dirname(__FILE__) + '/rlayout/box/table'
  require File.dirname(__FILE__) + '/rlayout/box/item_list'
  require File.dirname(__FILE__) + '/rlayout/box/title_box'
  require File.dirname(__FILE__) + '/rlayout/box/menu'
  require File.dirname(__FILE__) + '/rlayout/box/news_article_box'

  require File.dirname(__FILE__) + '/rlayout/quiz/english_quiz_item'
  require File.dirname(__FILE__) + '/rlayout/quiz/english_quiz_item_maker'
  require File.dirname(__FILE__) + '/rlayout/quiz/quiz_chapter_maker'
  require File.dirname(__FILE__) + '/rlayout/quiz/simple_table'
  require File.dirname(__FILE__) + '/rlayout/quiz/nr_semi_test'

  require File.dirname(__FILE__) + '/rlayout/math/eqn'
   require File.dirname(__FILE__) + '/rlayout/math/math_token'
   require File.dirname(__FILE__) + '/rlayout/math/latex_math'
   
   require File.dirname(__FILE__) + '/rlayout/page'
   require File.dirname(__FILE__) + '/rlayout/page/page_fixtures'
   require File.dirname(__FILE__) + '/rlayout/page/composite_page'
   require File.dirname(__FILE__) + '/rlayout/page_variables_extend'
   
   require File.dirname(__FILE__) + '/rlayout/document'
   require File.dirname(__FILE__) + '/rlayout/view/document_view_svg'
   require File.dirname(__FILE__) + '/rlayout/document_variables_extend'
   require File.dirname(__FILE__) + '/rlayout/story/story'
   require File.dirname(__FILE__) + '/rlayout/story/reader'
   require File.dirname(__FILE__) + '/rlayout/story/remote_reader'
   
   require File.dirname(__FILE__) + '/rlayout/article/chapter_maker'
   require File.dirname(__FILE__) + '/rlayout/article/news_article_maker'
   require File.dirname(__FILE__) + '/rlayout/article/news_section_page'
   require File.dirname(__FILE__) + '/rlayout/article/news_heading_maker'
   require File.dirname(__FILE__) + '/rlayout/article/magazine_article_maker'
   require File.dirname(__FILE__) + '/rlayout/article/single_page_maker'
   require File.dirname(__FILE__) + '/rlayout/article/rjob'
   require File.dirname(__FILE__) + '/rlayout/article/item_chapter_maker'
   
   require File.dirname(__FILE__) + '/rlayout/publication/book'
   require File.dirname(__FILE__) + '/rlayout/publication/book_plan'
   require File.dirname(__FILE__) + '/rlayout/publication/dorok'
   require File.dirname(__FILE__) + '/rlayout/publication/catalog'
   require File.dirname(__FILE__) + '/rlayout/publication/composite'
   require File.dirname(__FILE__) + '/rlayout/publication/magazine'
   require File.dirname(__FILE__) + '/rlayout/publication/mart'
   require File.dirname(__FILE__) + '/rlayout/publication/newspaper'
   require File.dirname(__FILE__) + '/rlayout/publication/photo_book'
   require File.dirname(__FILE__) + '/rlayout/publication/calendar'
   require File.dirname(__FILE__) + '/rlayout/publication/marathon_tag'
   require File.dirname(__FILE__) + '/rlayout/publication/member_directory'
   require File.dirname(__FILE__) + '/rlayout/publication/banner'
   
   require File.dirname(__FILE__) + '/rlayout/mlayout/mdocument'
end

module RLayout

end
