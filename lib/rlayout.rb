require "strscan"
require "yaml"
require "csv"
require "erb"
require "base64"
require "json"
require "image_processing/vips"
require "image_processing"
require "hexapdf"
require "text-hyphen"
require "rubypants-unicode"
require 'rqrcode'
require "pry-byebug"
require "debug"
# require "mini_magick"
# require "xml-simple"
require File.dirname(__FILE__) + "/rlayout/version"
require File.dirname(__FILE__) + "/rlayout/base/utility"
require File.dirname(__FILE__) + "/rlayout/base/color"
require File.dirname(__FILE__) + "/rlayout/base/graphic"
require File.dirname(__FILE__) + "/rlayout/base/container"
require File.dirname(__FILE__) + "/rlayout/base/rjob"
require File.dirname(__FILE__) + "/rlayout/base/styleable"

require File.dirname(__FILE__) + "/rlayout/base/text_area"
require File.dirname(__FILE__) + "/rlayout/base/text_bar"
require File.dirname(__FILE__) + "/rlayout/base/cover_page"
require File.dirname(__FILE__) + "/rlayout/base/info_area"

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

require File.dirname(__FILE__) + "/rlayout/container/auto_layout"
require File.dirname(__FILE__) + "/rlayout/container/pgscript"
require File.dirname(__FILE__) + "/rlayout/container/image_plus"

require File.dirname(__FILE__) + "/rlayout/grid/grid"
require File.dirname(__FILE__) + "/rlayout/grid/group_image"
require File.dirname(__FILE__) + "/rlayout/grid/grouped_caption"
require File.dirname(__FILE__) + "/rlayout/grid/grid_table"

require File.dirname(__FILE__) + "/rlayout/style/style_service"

require File.dirname(__FILE__) + "/rlayout/pdf/pdf_utils"

require File.dirname(__FILE__) + "/rlayout/view/svg_view/graphic_view_svg"
require File.dirname(__FILE__) + "/rlayout/view/svg_view/container_view_svg"
require File.dirname(__FILE__) + "/rlayout/view/svg_view/paragraph_view_svg"
require File.dirname(__FILE__) + "/rlayout/view/svg_view/r_text_token_view_svg"
require File.dirname(__FILE__) + "/rlayout/view/svg_view/r_line_fragment_view_svg"
require File.dirname(__FILE__) + "/rlayout/view/svg_view/r_page_view_svg"
require File.dirname(__FILE__) + "/rlayout/view/svg_view/r_document_view_svg"

require File.dirname(__FILE__) + "/rlayout/view/pdf_view/r_line_fragment_view_pdf"
require File.dirname(__FILE__) + "/rlayout/view/pdf_view/r_document_view_pdf"
require File.dirname(__FILE__) + "/rlayout/view/pdf_view/r_heading_pdf_view"  
require File.dirname(__FILE__) + "/rlayout/view/pdf_view/stroke"
require File.dirname(__FILE__) + "/rlayout/view/pdf_view/fill"
require File.dirname(__FILE__) + "/rlayout/view/pdf_view/image"

require File.dirname(__FILE__) + "/rlayout/view/pdf_view/graphic_view_pdf"
require File.dirname(__FILE__) + "/rlayout/view/pdf_view/container_view_pdf"
require File.dirname(__FILE__) + "/rlayout/view/pdf_view/grid_view_pdf"

require File.dirname(__FILE__) + "/rlayout/story/story"
require File.dirname(__FILE__) + "/rlayout/story/reader"
require File.dirname(__FILE__) + "/rlayout/story/remote_reader"

require File.dirname(__FILE__) + "/rlayout/document/r_text_token"
require File.dirname(__FILE__) + "/rlayout/document/r_paragraph"
require File.dirname(__FILE__) + "/rlayout/document/r_drop_para"
# require File.dirname(__FILE__) + "/rlayout/document/r_ordered_list"
require File.dirname(__FILE__) + "/rlayout/document/r_heading"
require File.dirname(__FILE__) + "/rlayout/document/r_line_fragment"
require File.dirname(__FILE__) + "/rlayout/document/r_column"
require File.dirname(__FILE__) + "/rlayout/document/r_text_box"
require File.dirname(__FILE__) + "/rlayout/document/r_document"
require File.dirname(__FILE__) + "/rlayout/document/r_page"

require File.dirname(__FILE__) + "/rlayout/text/font"
require File.dirname(__FILE__) + "/rlayout/text/quote_text"
require File.dirname(__FILE__) + "/rlayout/text/title_text"
require File.dirname(__FILE__) + "/rlayout/graphic/text_cell"

require File.dirname(__FILE__) + "/rlayout/text/text_train"

require File.dirname(__FILE__) + "/rlayout/table/list.rb"
require File.dirname(__FILE__) + "/rlayout/table/simple_table.rb"
require File.dirname(__FILE__) + "/rlayout/table/table.rb"
require File.dirname(__FILE__) + "/rlayout/table/table_row.rb"
require File.dirname(__FILE__) + "/rlayout/table/para_table.rb"
require File.dirname(__FILE__) + "/rlayout/table/para_table_row.rb"

require File.dirname(__FILE__) + "/rlayout/box_table/box_table_row"
require File.dirname(__FILE__) + "/rlayout/box_table/box_table"

require File.dirname(__FILE__) + "/rlayout/leader_table/leader_cell"
require File.dirname(__FILE__) + "/rlayout/leader_table/leader_row"
require File.dirname(__FILE__) + "/rlayout/leader_table/r_leader_table"
require File.dirname(__FILE__) + "/rlayout/leader_table/jubo"


require File.dirname(__FILE__) + "/rlayout/book/body_parser"
# require File.dirname(__FILE__) + "/rlayout/book/book_merger"
require File.dirname(__FILE__) + "/rlayout/book/toc"
require File.dirname(__FILE__) + "/rlayout/book/toc_page"
require File.dirname(__FILE__) + "/rlayout/book/book_cover"
require File.dirname(__FILE__) + "/rlayout/book/cover_spread"
require File.dirname(__FILE__) + "/rlayout/book/back_wing"
require File.dirname(__FILE__) + "/rlayout/book/back_page"
require File.dirname(__FILE__) + "/rlayout/book/column_article"
require File.dirname(__FILE__) + "/rlayout/book/chapter"
require File.dirname(__FILE__) + "/rlayout/book/seneca"
require File.dirname(__FILE__) + "/rlayout/book/front_page"
require File.dirname(__FILE__) + "/rlayout/book/front_wing"
require File.dirname(__FILE__) + "/rlayout/book/book_info_page"
require File.dirname(__FILE__) + "/rlayout/book/prologue"
require File.dirname(__FILE__) + "/rlayout/book/book_part"
require File.dirname(__FILE__) + "/rlayout/book/part_cover"
require File.dirname(__FILE__) + "/rlayout/book/poem"
require File.dirname(__FILE__) + "/rlayout/book/front_matter"
require File.dirname(__FILE__) + "/rlayout/book/body_matter"
require File.dirname(__FILE__) + "/rlayout/book/rear_matter"
require File.dirname(__FILE__) + "/rlayout/book/book"
require File.dirname(__FILE__) + "/rlayout/book/paperback"
require File.dirname(__FILE__) + "/rlayout/book/essay_book"
require File.dirname(__FILE__) + "/rlayout/book/poetry_book"
require File.dirname(__FILE__) + "/rlayout/book/print_page"
require File.dirname(__FILE__) + "/rlayout/book/pdf_section"
require File.dirname(__FILE__) + "/rlayout/book/isbn"
require File.dirname(__FILE__) + "/rlayout/book/thanks"
require File.dirname(__FILE__) + "/rlayout/book/dedication"
require File.dirname(__FILE__) + "/rlayout/book/inside_cover"
require File.dirname(__FILE__) + "/rlayout/book/book_cover_wing"
require File.dirname(__FILE__) + "/rlayout/book/book_parser_txt"
require File.dirname(__FILE__) + "/rlayout/book/book_parser_md"
require File.dirname(__FILE__) + "/rlayout/book/title_page"
require File.dirname(__FILE__) + "/rlayout/book/blank_page"
require File.dirname(__FILE__) + "/rlayout/book/help"

require File.dirname(__FILE__) + "/rlayout/page_by_page/page_by_page"
require File.dirname(__FILE__) + "/rlayout/page_by_page/fit_page"
require File.dirname(__FILE__) + "/rlayout/page_by_page/r_line_fragment"

# require File.dirname(__FILE__) + "/rlayout/styleable/book_promo"

require File.dirname(__FILE__) + "/rlayout/namecard/card_page"
require File.dirname(__FILE__) + "/rlayout/namecard/namecard"
require File.dirname(__FILE__) + "/rlayout/namecard/card_step_and_reapeat"

require File.dirname(__FILE__) + "/rlayout/newspaper/news_box"
require File.dirname(__FILE__) + "/rlayout/view/pdf_view/news_article_view"

require File.dirname(__FILE__) + "/rlayout/newspaper/caption_paragraph"
require File.dirname(__FILE__) + "/rlayout/newspaper/caption_column"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_box_ad"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_heading_maker"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_heading_for_article"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_heading_for_opinion"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_heading_for_editorial"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_heading_for_special"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_heading_for_obituary"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_heading_for_book_review"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_float"
require File.dirname(__FILE__) + "/rlayout/newspaper/announcement_text"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_image"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_quote"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_column_image"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_image_box"
require File.dirname(__FILE__) + "/rlayout/newspaper/profile_image"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_article_box"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_box_maker"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_toc"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_pillar"
require File.dirname(__FILE__) + "/rlayout/newspaper/news_page"

require File.dirname(__FILE__) + "/rlayout/news/news_article"
require File.dirname(__FILE__) + "/rlayout/news/news_heading"
require File.dirname(__FILE__) + "/rlayout/news/news_page_parser"
require File.dirname(__FILE__) + "/rlayout/news/news_page_builder"
require File.dirname(__FILE__) + "/rlayout/news/news_publication"
require File.dirname(__FILE__) + "/rlayout/news/news_page_pdf_merger"
require File.dirname(__FILE__) + "/rlayout/news/news_issue_plan"
require File.dirname(__FILE__) + "/rlayout/news/news_issue_builder"

require File.dirname(__FILE__) + "/rlayout/magazine/magazine_article.rb"
require File.dirname(__FILE__) + "/rlayout/magazine/magazine_cover.rb"

require File.dirname(__FILE__) + "/rlayout/svg/circle"
require File.dirname(__FILE__) + "/rlayout/svg/image"
require File.dirname(__FILE__) + "/rlayout/svg/line"
require File.dirname(__FILE__) + "/rlayout/svg/path"
require File.dirname(__FILE__) + "/rlayout/svg/polygon"
require File.dirname(__FILE__) + "/rlayout/svg/rectangle"
require File.dirname(__FILE__) + "/rlayout/svg/text"
# require File.dirname(__FILE__) + "/rlayout/svg/svg2pdf"

require File.dirname(__FILE__) + "/rlayout/math/latex_token"

require File.dirname(__FILE__) + "/rlayout/deco_text/deco_string"
require File.dirname(__FILE__) + "/rlayout/deco_text/deco_char"

require File.dirname(__FILE__) + "/rlayout/yearbook/yearbook"
require File.dirname(__FILE__) + "/rlayout/yearbook/yb_page"
require File.dirname(__FILE__) + "/rlayout/yearbook/yb_section"

require File.dirname(__FILE__) + "/rlayout/picture_book/picture_spread_page"
require File.dirname(__FILE__) + "/rlayout/picture_book/picture_spread"
require File.dirname(__FILE__) + "/rlayout/picture_book/body_matter_with_picture_spread"
require File.dirname(__FILE__) + "/rlayout/picture_book/picture_book"

require File.dirname(__FILE__) + "/rlayout/church/ch_section"
require File.dirname(__FILE__) + "/rlayout/church/ch_page"
require File.dirname(__FILE__) + "/rlayout/church/ch_index"
require File.dirname(__FILE__) + "/rlayout/church/ch_index_page"

require File.dirname(__FILE__) + "/rlayout/qrcode/qr_generator"

module RLayout

end

