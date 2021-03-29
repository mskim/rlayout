
# MagazineArticle
# MagazineArticle has fixed page_count.
# MagazineArticle has floats_layout.
# The idea is to have two layers, body layer and floats layer.
# Floats are layout first and body contents are layed out avoding the floats.
# floats are
#    heading, quote, leading
#    image, group_image, graphic, table, side_box
#    decoration
# 
# There should be pre-designed floats layout template.
# for example, pre-designed floats layout for
#   single_left_page
#   single_right_page
#   double_page
#   double_page_ending
#   MagazineArticleTemplate

module RLayout
  class MagazineArticle < RDocument
    attr_accessor :profile, :page_count, :images, :group_images, :graphics, :tables, :side_boxes
    def initialize(options={}, &block)
      options[:page_size]  = 'A4'     unless options[:page_size]
      options[:page_count] = 1        unless options[:page_count]
      options[:width]      = 595.28   unless options[:width]
      options[:height]     = 841.89   unless options[:height]
      super
      if block
        instance_eval(&block)
      end
      self
    end
  end

end