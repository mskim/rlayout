
module RLayout
 
  class NewsArticle < Page
    attr_accessor :story_path, :heading, :paragraphs
    attr_accessor :heading_width
    attr_accessor :output_path
    def initialize(parent_graphic, options={})
      @output_path = options[:output_path] if options[:output_path]
      if options[:grid_frame]
        options[:column_count]= options[:grid_frame][2]
        options[:grid_width]  = 200 unless options[:grid_width]
        options[:grid_height] = 200 unless options[:grid_height]
        options[:gutter]      = 5 unless options[:gutter]
        options[:v_gutter]    = 0 unless options[:v_gutter]
        options[:width]       = options[:grid_frame][2]*options[:grid_width] + (options[:grid_frame][2] - 1)*options[:gutter]
        options[:height]      = options[:grid_frame][3]*options[:grid_height] + ((options[:grid_frame][3] - 1)*options[:v_gutter])
        options[:column_count]= options[:grid_frame][2]
      end
      options[:text_box]      = true
      options[:left_margin]   = 5 unless options[:left_margin]
      options[:top_margin]    = 5 unless options[:top_margin]
      options[:right_margin]  = 5 unless options[:right_margin]
      options[:bottom_margin] = 5 unless options[:bottom_margin]
      
      if options[:story_path]
        @story_path = options[:story_path]
        read_story
      elsif options[:story_hash] 
        @heading    = options[:story_hash][:heading]        
        if @heading[:heading_columns]
          @heading_columns = @heading[:heading_columns]
        end
        @paragraphs = []
        para_data_array = Story.parse_markdown(options[:story_hash][:body_markdown])
        make_paragraph(para_data_array)
      end
      options[:chapter_kind]  = "news_article"
      options[:x]             = options.fetch(:x, 0)
      options[:y]             = options.fetch(:y, 0)
      super
      layout_story
      if @output_path
        save_pdf(@output_path)
      end
      self
    end
    
    def current_style
      NEWS_STYLES
    end
    
    # path to story is given  
    def read_story
      story         = Story.from_meta_markdown(@story_path)
      @heading      = story.heading
      # @title        = @heading[:title]
      if @heading[:heading_columns]
        @heading_columns = @heading[:heading_columns]
      else
        @heading_columns = @grid_frame[2]
      end
      @paragraphs         =[]
      make_paragraph(story.paragraphs)
    end
        
    def make_paragraph(para_data_array)
      @paragraphs         =[]
      para_data_array.each do |para| 
        para_options      = {}
        para_options[:markup]         = para[:markup]
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
        para_options[:chapter_kind]   = "news_article"
        @paragraphs << Paragraph.new(nil, para_options)    
      end
    end
    
    def layout_story
      @heading[:layout_expand]  = [:height]
      # @heading[:line_width]     = 2
      # @heading[:line_color]     = 'red'
      @heading[:width]          = @main_box.heading_width
      @heading[:align_to_body_text]= true
      @heading[:layout_expand]  = nil
      @heading[:top_margin]     = 0
      @heading[:top_inset]      = 10
      @heading[:bottom_margin]  = 0
      @heading[:tottom_inset]   = 10
      @heading[:left_inset]     = 0
      @heading[:right_inset]    = 0
      @heading[:chapter_kind]   = "news_article"
      @heading[:current_style]  = NEWS_STYLES
      @main_box.floats << Heading.new(nil, @heading)
      relayout!
      @main_box.set_non_overlapping_frame_for_chidren_graphics        
      @main_box.layout_items(@paragraphs)
      
    end
  end
  
end

