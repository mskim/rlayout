
# NewsArticleBox 
# grid_frame is passed to detemine the width, height, and column_number of text_box
# Used when creating NewsArticle

module RLayout

  class NewsArticleBox < TextBox
    attr_accessor :story_path

    def initialize(parent_graphic, options={}, &block)
      if options[:grid_frame]
        if options[:grid_frame].class == String
          options[:grid_frame] = eval(options[:grid_frame])
        end
        if options[:grid_size].class == String
          options[:grid_size] = eval(options[:grid_size])
        end
        
        if options[:grid_width].class == String
          options[:grid_width] = eval(options[:grid_width])
        end
        if options[:grid_height].class == String
          options[:grid_height] = eval(options[:grid_height])
        end
        @heading_columns = options[:grid_frame][2]
        @heading_columns = HEADING_COLUMNS_TABLE[options[:grid_frame][2].to_i]
        options[:grid_frame]  = eval(options[:grid_frame]) if options[:grid_frame].class == String
        options[:column_count]= options[:grid_frame][2]
        @grid_width           = options.fetch(:grid_width, 200)
        @grid_height          = options.fetch(:grid_height, 200)
        options[:gutter]      = 10 unless options[:gutter]
        options[:v_gutter]    = 0 unless options[:v_gutter]
        options[:width]       = options[:grid_frame][2]*options[:grid_width] + (options[:grid_frame][2] - 1)*options[:gutter]
        options[:height]      = options[:grid_frame][3]*options[:grid_height] + ((options[:grid_frame][3] - 1)*options[:v_gutter])
        options[:column_count]= options[:grid_frame][2]
      end
      options[:left_margin]   = 5 unless options[:left_margin]
      options[:top_margin]    = 5 unless options[:top_margin]
      options[:right_margin]  = 5 unless options[:right_margin]
      options[:bottom_margin] = 5 unless options[:bottom_margin]
      super
      self
    end


    def make_paragraph(para_data_array)
      @paragraphs =[]
      para_data_array.each do |para|
        para_options  ={}
        para_options[:markup]  = para[:markup]
        if para[:markup] == 'img'
          source                      = para[:image_path]
          para_options[:caption]      = para[:caption]
          para_options[:layout_expand]= [:width]
          para_options[:bottom_margin]= 10
          para_options[:bottom_inset] = 10
          full_image_path = File.dirname(@story_path) + "/#{source}"
          para_options[:image_path]   = full_image_path
          @paragraphs << Image.new(nil, para_options)
          next
        end
        para_options[:text_string]    = para[:string]
        para_options[:layout_expand]  = [:width]
        para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:article_type]   = "news_article"
        para_options[:layout_lines]   = false
        @paragraphs << Paragraph.new(nil, para_options)
      end
    end

  end

end
