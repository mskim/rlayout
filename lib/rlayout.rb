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
else
  require 'strscan'
  require 'yaml'
  require 'csv'
  require 'erb'
  require 'base64'
  require 'json'
  require "image_processing/vips"
  require "image_processing"
  require 'hexapdf'
  require 'text-hyphen'
  require 'rubypants-unicode'
  # require 'debug'
  # require 'pry'
  # require 'byebug'

  require 'pry-byebug'
  # require 'mini_magick'
  # require 'xml-simple'

  require File.dirname(__FILE__) + "/rlayout/version"
  require File.dirname(__FILE__) + '/rlayout/base/utility'
  require File.dirname(__FILE__) + '/rlayout/base/color'
  require File.dirname(__FILE__) + '/rlayout/base/graphic'
  require File.dirname(__FILE__) + '/rlayout/base/container'
  require File.dirname(__FILE__) + '/rlayout/base/page'
  require File.dirname(__FILE__) + '/rlayout/base/document'
  require File.dirname(__FILE__) + '/rlayout/base/rjob'

  require File.dirname(__FILE__) + "/rlayout/graphic/fill"
  require File.dirname(__FILE__) + "/rlayout/graphic/graphic_struct"
  require File.dirname(__FILE__) + "/rlayout/graphic/text"

  require File.dirname(__FILE__) + "/rlayout/graphic/image"
  require File.dirname(__FILE__) + "/rlayout/graphic/layout"
  require File.dirname(__FILE__) + "/rlayout/graphic/node_tree"
  require File.dirname(__FILE__) + "/rlayout/graphic/rotation"
  require File.dirname(__FILE__) + "/rlayout/graphic/shadow"
  require File.dirname(__FILE__) + "/rlayout/graphic/shape"
  require File.dirname(__FILE__) + "/rlayout/graphic/stroke"
  require File.dirname(__FILE__) + "/rlayout/graphic/random_graphic"
  require File.dirname(__FILE__) + "/rlayout/graphic/minsoolian"

  require File.dirname(__FILE__) + '/rlayout/container/auto_layout'
  require File.dirname(__FILE__) + '/rlayout/container/pgscript'
  require File.dirname(__FILE__) + '/rlayout/container/image_plus'

  require File.dirname(__FILE__) + '/rlayout/grid/grid'
  require File.dirname(__FILE__) + '/rlayout/grid/group_image'
  require File.dirname(__FILE__) + '/rlayout/grid/grouped_caption'
  require File.dirname(__FILE__) + '/rlayout/grid/grid_table'

  # require File.dirname(__FILE__) + '/rlayout/db_publishing/db_item'
  # require File.dirname(__FILE__) + '/rlayout/container_extended/photo_item'
  # require File.dirname(__FILE__) + '/rlayout/container_extended/place_item'
  # require File.dirname(__FILE__) + '/rlayout/container_extended/memo_area'

  require File.dirname(__FILE__) + '/rlayout/style/style_service'
  # require File.dirname(__FILE__) + '/rlayout/style/grid_layout'
  # require File.dirname(__FILE__) + '/rlayout/style/image_layout'
  require File.dirname(__FILE__) + '/rlayout/pdf/pdf_utils'

  require File.dirname(__FILE__) + "/rlayout/view/svg_view/graphic_view_svg"
  require File.dirname(__FILE__) + "/rlayout/view/svg_view/container_view_svg"
  require File.dirname(__FILE__) + '/rlayout/view/svg_view/paragraph_view_svg'
  require File.dirname(__FILE__) + '/rlayout/view/svg_view/r_text_token_view_svg'
  require File.dirname(__FILE__) + '/rlayout/view/svg_view/r_line_fragment_view_svg'
  require File.dirname(__FILE__) + '/rlayout/view/svg_view/r_page_view_svg'
  require File.dirname(__FILE__) + '/rlayout/view/svg_view/r_document_view_svg'

  # require File.dirname(__FILE__) + '/rlayout/view/pdf_view/r_text_token_view_pdf'
  require File.dirname(__FILE__) + '/rlayout/view/pdf_view/r_line_fragment_view_pdf'
  require File.dirname(__FILE__) + '/rlayout/view/pdf_view/r_document_view_pdf'
  require File.dirname(__FILE__) + '/rlayout/view/pdf_view/r_heading_pdf_view'  
  require File.dirname(__FILE__) + '/rlayout/view/pdf_view/stroke'
  require File.dirname(__FILE__) + '/rlayout/view/pdf_view/fill'
  require File.dirname(__FILE__) + '/rlayout/view/pdf_view/image'
  require File.dirname(__FILE__) + '/rlayout/view/pdf_view/text'
  require File.dirname(__FILE__) + '/rlayout/view/pdf_view/graphic_view_pdf'
  require File.dirname(__FILE__) + '/rlayout/view/pdf_view/container_view_pdf'
  require File.dirname(__FILE__) + '/rlayout/view/pdf_view/grid_view_pdf'

  require File.dirname(__FILE__) + '/rlayout/story/story'
  require File.dirname(__FILE__) + '/rlayout/story/reader'
  require File.dirname(__FILE__) + '/rlayout/story/remote_reader'

  require File.dirname(__FILE__) + '/rlayout/chapter/r_text_token'
  require File.dirname(__FILE__) + '/rlayout/chapter/r_paragraph'
  require File.dirname(__FILE__) + '/rlayout/chapter/r_heading'
  require File.dirname(__FILE__) + '/rlayout/chapter/r_line_fragment'
  require File.dirname(__FILE__) + '/rlayout/chapter/r_column'
  require File.dirname(__FILE__) + '/rlayout/chapter/r_text_box'
  require File.dirname(__FILE__) + '/rlayout/chapter/r_document'
  require File.dirname(__FILE__) + '/rlayout/chapter/r_page'
  require File.dirname(__FILE__) + '/rlayout/chapter/r_chapter'

  require File.dirname(__FILE__) + '/rlayout/text/font'
  require File.dirname(__FILE__) + '/rlayout/text/announcement_text'
  require File.dirname(__FILE__) + '/rlayout/text/quote_text'
  require File.dirname(__FILE__) + '/rlayout/text/title_text'
  require File.dirname(__FILE__) + "/rlayout/text/text_token"
  require File.dirname(__FILE__) + '/rlayout/graphic/text_cell'

  require File.dirname(__FILE__) + "/rlayout/text/text_train"
  require File.dirname(__FILE__) + '/rlayout/text/heading'
  
  require File.dirname(__FILE__) + '/rlayout/table/list.rb'
  require File.dirname(__FILE__) + '/rlayout/table/simple_table.rb'
  require File.dirname(__FILE__) + '/rlayout/table/table.rb'
  require File.dirname(__FILE__) + '/rlayout/table/table_row.rb'

  require File.dirname(__FILE__) + '/rlayout/box_table/box_table_row'
  require File.dirname(__FILE__) + '/rlayout/box_table/box_table'

  require File.dirname(__FILE__) + '/rlayout/leader_table/leader_cell'
  require File.dirname(__FILE__) + '/rlayout/leader_table/leader_row'
  require File.dirname(__FILE__) + '/rlayout/leader_table/r_leader_table'
  require File.dirname(__FILE__) + '/rlayout/leader_table/jubo'

  require File.dirname(__FILE__) + '/rlayout/book/toc'
  require File.dirname(__FILE__) + '/rlayout/book/toc_page'
  require File.dirname(__FILE__) + '/rlayout/book/book_cover'
  require File.dirname(__FILE__) + '/rlayout/book/cover_spread'
  require File.dirname(__FILE__) + '/rlayout/book/back_wing'
  require File.dirname(__FILE__) + '/rlayout/book/back_page'
  require File.dirname(__FILE__) + '/rlayout/book/seneca'
  require File.dirname(__FILE__) + '/rlayout/book/front_page'
  require File.dirname(__FILE__) + '/rlayout/book/front_wing'
  require File.dirname(__FILE__) + '/rlayout/book/title_page'
  require File.dirname(__FILE__) + '/rlayout/book/book_info_page'
  require File.dirname(__FILE__) + '/rlayout/book/prologue'
  require File.dirname(__FILE__) + '/rlayout/book/book_part'
  require File.dirname(__FILE__) + '/rlayout/book/part_cover'
  require File.dirname(__FILE__) + '/rlayout/book/poem'
  require File.dirname(__FILE__) + '/rlayout/book/front_matter'
  require File.dirname(__FILE__) + '/rlayout/book/body_matter'
  require File.dirname(__FILE__) + '/rlayout/book/body_matter_with_part'
  require File.dirname(__FILE__) + '/rlayout/book/rear_matter'
  require File.dirname(__FILE__) + '/rlayout/book/book'
  require File.dirname(__FILE__) + '/rlayout/book/book_with_parts'
  require File.dirname(__FILE__) + '/rlayout/book/paperback'
  require File.dirname(__FILE__) + '/rlayout/book/essay_book'
  require File.dirname(__FILE__) + '/rlayout/book/poetry_book'
  require File.dirname(__FILE__) + '/rlayout/book/print_page'
  require File.dirname(__FILE__) + '/rlayout/book/pdf_section'

  require File.dirname(__FILE__) + '/rlayout/newspaper/news_box'
  require File.dirname(__FILE__) + '/rlayout/view/pdf_view/news_article_view'

  require File.dirname(__FILE__) + '/rlayout/newspaper/caption_paragraph'
  require File.dirname(__FILE__) + '/rlayout/newspaper/caption_column'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_box_ad'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_heading_maker'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_heading_for_article'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_heading_for_opinion'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_heading_for_editorial'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_heading_for_special'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_heading_for_obituary'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_heading_for_book_review'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_float'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_image'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_quote'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_column_image'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_image_box'
  require File.dirname(__FILE__) + '/rlayout/newspaper/profile_image'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_article_box'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_box_maker'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_toc'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_pillar'
  require File.dirname(__FILE__) + '/rlayout/newspaper/news_page'

  require File.dirname(__FILE__) + '/rlayout/magazine/magazine_article.rb'
  require File.dirname(__FILE__) + '/rlayout/magazine/cover.rb'

  require File.dirname(__FILE__) + "/rlayout/svg/circle"
  require File.dirname(__FILE__) + "/rlayout/svg/image"
  require File.dirname(__FILE__) + "/rlayout/svg/line"
  require File.dirname(__FILE__) + "/rlayout/svg/path"
  require File.dirname(__FILE__) + "/rlayout/svg/polygon"
  require File.dirname(__FILE__) + "/rlayout/svg/rectangle"
  require File.dirname(__FILE__) + "/rlayout/svg/text"
  # require File.dirname(__FILE__) + "/rlayout/svg/svg2pdf"

  # require File.dirname(__FILE__) + '/rlayout/math/eqn'
  # require File.dirname(__FILE__) + '/rlayout/math/math_token'
  # require File.dirname(__FILE__) + '/rlayout/math/latex_math'

  # require File.dirname(__FILE__) + '/rlayout/page/page_fixtures'
  # require File.dirname(__FILE__) + '/rlayout/page/composite_page'
  # require File.dirname(__FILE__) + '/rlayout/page/page_variables_extend'


  
  require File.dirname(__FILE__) + "/rlayout/deco_text/deco_string"
  require File.dirname(__FILE__) + "/rlayout/deco_text/deco_char"


  require File.dirname(__FILE__) + '/rlayout/article/float_group'

  require File.dirname(__FILE__) + '/rlayout/yearbook/yearbook'
  require File.dirname(__FILE__) + '/rlayout/yearbook/yb_page'
  require File.dirname(__FILE__) + '/rlayout/yearbook/yb_section'

  require File.dirname(__FILE__) + '/rlayout/picture_book/picture_spread_page'
  require File.dirname(__FILE__) + '/rlayout/picture_book/picture_spread'
  require File.dirname(__FILE__) + '/rlayout/picture_book/body_matter_with_picture_spread'
  require File.dirname(__FILE__) + '/rlayout/picture_book/picture_book'

  require File.dirname(__FILE__) + '/rlayout/church/ch_section'
  require File.dirname(__FILE__) + '/rlayout/church/ch_page'
  require File.dirname(__FILE__) + '/rlayout/church/ch_index'
  require File.dirname(__FILE__) + '/rlayout/church/ch_index_page'


end

module RLayout

end

