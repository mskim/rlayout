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
  require 'pry'
  require 'strscan'
  require 'yaml'
  require 'csv'
  require 'erb'
  require 'base64'
  
  require File.dirname(__FILE__) + "/rlayout/version"
  require File.dirname(__FILE__) + '/rlayout/utility'
  require File.dirname(__FILE__) + '/rlayout/graphic'
  require File.dirname(__FILE__) + '/rlayout/container'
  
  
  require File.dirname(__FILE__) + '/rlayout/text/heading'
  require File.dirname(__FILE__) + '/rlayout/text/heading_container'
  require File.dirname(__FILE__) + '/rlayout/text/paragraph'
  require File.dirname(__FILE__) + '/rlayout/text/paragraph_ns_text'
  require File.dirname(__FILE__) + '/rlayout/text/text_token'
  require File.dirname(__FILE__) + '/rlayout/text/text_layout_manager'
  require File.dirname(__FILE__) + '/rlayout/text/font'
  require File.dirname(__FILE__) + '/rlayout/text/text_train'
  require File.dirname(__FILE__) + '/rlayout/text/title_text'
  require File.dirname(__FILE__) + '/rlayout/text/ordered_list'
  require File.dirname(__FILE__) + '/rlayout/text/text_column'
  require File.dirname(__FILE__) + '/rlayout/text/text_box'

  require File.dirname(__FILE__) + '/rlayout/table/simple_table'
  require File.dirname(__FILE__) + '/rlayout/table/table'
  require File.dirname(__FILE__) + '/rlayout/table/toc_table'

  require File.dirname(__FILE__) + '/rlayout/container_extended/photo_item'
  require File.dirname(__FILE__) + '/rlayout/container_extended/place_item'
  require File.dirname(__FILE__) + '/rlayout/container_extended/memo_area'

  require File.dirname(__FILE__) + '/rlayout/style/style_service'
  require File.dirname(__FILE__) + '/rlayout/style/grid_layout'
  require File.dirname(__FILE__) + '/rlayout/style/image_layout'
  
  require File.dirname(__FILE__) + '/rlayout/box/box_ad_box'
  require File.dirname(__FILE__) + '/rlayout/box/image_box'
  require File.dirname(__FILE__) + '/rlayout/box/object_box'
  require File.dirname(__FILE__) + '/rlayout/box/grid_box'
  require File.dirname(__FILE__) + '/rlayout/box/composite_box'
  require File.dirname(__FILE__) + '/rlayout/box/item_list'
  require File.dirname(__FILE__) + '/rlayout/box/title_box'
  require File.dirname(__FILE__) + '/rlayout/box/news_article_box'
  require File.dirname(__FILE__) + '/rlayout/box/menu'

  require File.dirname(__FILE__) + '/rlayout/math/eqn'
  require File.dirname(__FILE__) + '/rlayout/math/math_token'
  require File.dirname(__FILE__) + '/rlayout/math/latex_math'

  require File.dirname(__FILE__) + '/rlayout/page'
  require File.dirname(__FILE__) + '/rlayout/page/page_fixtures'
  require File.dirname(__FILE__) + '/rlayout/page/composite_page'
  require File.dirname(__FILE__) + '/rlayout/page/page_variables_extend'
   
  require File.dirname(__FILE__) + '/rlayout/document'
  require File.dirname(__FILE__) + '/rlayout/view/document_view_svg'
  require File.dirname(__FILE__) + '/rlayout/document_variables_extend'
  require File.dirname(__FILE__) + '/rlayout/story/story'
  require File.dirname(__FILE__) + '/rlayout/story/reader'
  require File.dirname(__FILE__) + '/rlayout/story/remote_reader'


  require File.dirname(__FILE__) + '/rlayout/article/pdf_chapter'
  require File.dirname(__FILE__) + '/rlayout/article/chapter'
  require File.dirname(__FILE__) + '/rlayout/article/spread_chapter'
  require File.dirname(__FILE__) + '/rlayout/article/toc_chapter'
  require File.dirname(__FILE__) + '/rlayout/article/float_group'
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

  require File.dirname(__FILE__) + '/rlayout/quiz/english_quiz_item'
  require File.dirname(__FILE__) + '/rlayout/quiz/english_quiz_item_maker'
  require File.dirname(__FILE__) + '/rlayout/quiz/quiz_chapter_maker'
  require File.dirname(__FILE__) + '/rlayout/quiz/nr_semi_test_chapter_maker'

  require File.dirname(__FILE__) + '/rlayout/mlayout/mdocument'
end

module RLayout

end
