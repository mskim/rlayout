
if defined?(Motion::Project::Config)
  
  Motion::Project::App.setup do |app|
    Dir.glob(File.join(File.dirname(__FILE__), 'rlayout/**/*.rb')).each do |file|
      app.files.unshift(file)
    end
  end
  #
  # raise "This file must be required within a RubyMotion project Rakefile."
  
else
  # do usual require here.
  require_relative 'graphic/fill'
  require_relative 'graphic/image'
  require_relative 'graphic/layout'
  require_relative 'graphic/line'
  require_relative 'graphic/node_tree'
  require_relative 'graphic/text'
  require_relative 'graphic'
  
  require_relative 'container/auto_layout'
  require_relative 'container/float'
  require_relative 'container/grid'
  require_relative 'container/pgscript'
  require_relative 'container/photo_item'
  require_relative 'container/place_item'
  require_relative 'container/quiz_item'
  require_relative 'container/table'
  require_relative 'container/text_form'
  require_relative 'container'
  
  require_relative 'text/heading'
  require_relative 'text/paragraph'
  require_relative 'text/style_service'
  require_relative 'text/text_layout_manager'
  
  require_relative 'title_box'
  require_relative 'text_column'
  require_relative 'text_box'
  
  require_relative 'page/page_fixtures'
  require_relative 'page/composite_page'
  require_relative 'page'
  require_relative 'page_variables_extend'
  
  require_relative 'document'
  require_relative 'document_variables_extend'
  
  require_relative 'publication/book'
  require_relative 'publication/catalog'
  require_relative 'publication/composite'
  require_relative 'publication/magazine'
  require_relative 'publication/mart'
  require_relative 'publication/newspaper'
  require_relative 'publication/photo_book'
  
end

