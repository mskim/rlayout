
# MagazineArticle
# MagazineArticle has fixed page_count.
# MagazineArticle has floats_layout.
# The idea is to have two layers, body layer and floats layer.
# Floats are layout first and body contents are layed out avoding the floats.
# floats are
#    heading
#    image, graphic, table, side_box
#    decoration
# 
# There should be pre-designed floats layout template.
# for example, pre-designed floats layout for
#   single_left_page
#   single_right_page
#   double_page
#   double_page_ending

# profile: category_heading_floats
#   left_h_0
#   left_h_1
#   left_h_2
#   left_h_3
#   left_h_4
#   left_0
#   left_1
#   left_2
#   left_3
#   right_h_0
#   right_h_2
#   right_h_3
#   right_h_4
#   right_0
#   right_1
#   right_2
#   right_3
#   spread_h_0
#   spread_h_2
#   spread_h_3
#   spread_h_4
#   spread_0
#   spread_1
#   spread_2
#   spread_3

# category: left, right, spread

module RLayout
  class MagazineArticleTemplate < Container
    attr_accessor :profile, :category


  end
end