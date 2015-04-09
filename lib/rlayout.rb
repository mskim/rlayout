
if defined?(Motion::Project::Config)

  Motion::Project::App.setup do |app|
    Dir.glob(File.join(File.dirname(__FILE__), 'rlayout/**/*.rb')).each do |file|
      app.files.unshift(file)
    end
  end
  #
  # raise "This file must be required within a RubyMotion project Rakefile."

else
  if RUBY_ENGINE == "macruby"
    framework 'cocoa'
    framework 'Quartz'
  end
  require 'strscan'
  require 'yaml'

  require File.dirname(__FILE__) + '/rlayout/utility'
  require File.dirname(__FILE__) + '/rlayout/graphic/grid_pattern'
  require File.dirname(__FILE__) + '/rlayout/graphic/fill'
  require File.dirname(__FILE__) + '/rlayout/graphic/image'
  require File.dirname(__FILE__) + '/rlayout/graphic/layout'
  require File.dirname(__FILE__) + '/rlayout/graphic/line'
  require File.dirname(__FILE__) + '/rlayout/graphic/node_tree'
  require File.dirname(__FILE__) + '/rlayout/graphic/text'
  require File.dirname(__FILE__) + '/rlayout/graphic'

  if RUBY_ENGINE == "macruby"
    require File.dirname(__FILE__) + '/rlayout/view/graphic_view_mac'
    require File.dirname(__FILE__) + '/rlayout/view/document_view_mac'
  end
  require File.dirname(__FILE__) + '/rlayout/view/graphic_view_svg'

  require File.dirname(__FILE__) + '/rlayout/container'
  require File.dirname(__FILE__) + '/rlayout/container/auto_layout'
  require File.dirname(__FILE__) + '/rlayout/container/float'
  require File.dirname(__FILE__) + '/rlayout/container/grid'
  require File.dirname(__FILE__) + '/rlayout/container/pgscript'
  require File.dirname(__FILE__) + '/rlayout/container/table'
  require File.dirname(__FILE__) + '/rlayout/container/text_form'

  require File.dirname(__FILE__) + '/rlayout/text/heading'
  require File.dirname(__FILE__) + '/rlayout/text/paragraph'
  require File.dirname(__FILE__) + '/rlayout/text/style_service'
  require File.dirname(__FILE__) + '/rlayout/text/text_layout_manager'

  require File.dirname(__FILE__) + '/rlayout/container/photo_item'
  require File.dirname(__FILE__) + '/rlayout/container/place_item'
  require File.dirname(__FILE__) + '/rlayout/container/quiz_item'

  require File.dirname(__FILE__) + '/rlayout/title_box'
  require File.dirname(__FILE__) + '/rlayout/text_column'
  require File.dirname(__FILE__) + '/rlayout/text_box'

  require File.dirname(__FILE__) + '/rlayout/page'
  require File.dirname(__FILE__) + '/rlayout/page/page_fixtures'
  require File.dirname(__FILE__) + '/rlayout/page/composite_page'
  require File.dirname(__FILE__) + '/rlayout/page_variables_extend'

  require File.dirname(__FILE__) + '/rlayout/document'
  require File.dirname(__FILE__) + '/rlayout/document_variables_extend'

  require File.dirname(__FILE__) + '/rlayout/article/story'
  require File.dirname(__FILE__) + '/rlayout/article/reader'
  require File.dirname(__FILE__) + '/rlayout/article/chapter'
  require File.dirname(__FILE__) + '/rlayout/article/news_article'
  require File.dirname(__FILE__) + '/rlayout/article/magazine_article'

  require File.dirname(__FILE__) + '/rlayout/publication/rjob'
  require File.dirname(__FILE__) + '/rlayout/publication/book'
  require File.dirname(__FILE__) + '/rlayout/publication/book'
  require File.dirname(__FILE__) + '/rlayout/publication/chapter_maker'
  require File.dirname(__FILE__) + '/rlayout/publication/catalog'
  require File.dirname(__FILE__) + '/rlayout/publication/composite'
  require File.dirname(__FILE__) + '/rlayout/publication/magazine'
  require File.dirname(__FILE__) + '/rlayout/publication/mart'
  require File.dirname(__FILE__) + '/rlayout/publication/newspaper'
  require File.dirname(__FILE__) + '/rlayout/publication/news_article_maker'
  require File.dirname(__FILE__) + '/rlayout/publication/photo_book'

end

module RLayout

end
