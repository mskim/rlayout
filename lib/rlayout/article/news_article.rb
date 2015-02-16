
module RLayout
 
  class NewsArticle < Page
    attr_accessor :story_path, :paragraphs #:heading, :images
    attr_accessor :output_path
    def initialize(parent_graphic, options={})
      if options[:project_path]
      
      end
      @output_path = options[:output_path] if options[:output_path]
      options[:chapter_kind]  = "news_article"
      options[:x]             = options.fetch(:x, 0)
      options[:y]             = options.fetch(:y, 0)
      if options[:grid_frame]
        @heading_columns = options[:grid_frame][2]
        options[:grid_frame] = eval(options[:grid_frame]) if options[:grid_frame].class == String
        options[:column_count]= options[:grid_frame][2]
        @grid_width  = options.fetch(:grid_width, 200)
        @grid_height  = options.fetch(:grid_height, 200)
        options[:gutter]      = 10 unless options[:gutter]
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
      elsif options[:story] 
        @heading_options    = options[:story][:heading]
        @images     = options[:images] 
        if @heading_options[:heading_columns]
          @heading_columns = @heading_options[:heading_columns]
        end
        @paragraphs = []
        para_data_array = Story.parse_markdown(options[:story][:body_markdown])
        make_paragraph(para_data_array)
      end
      super
      layout_story unless options[:is_template]
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
      @heading_options      = story.heading
      @images       = story.images #TODO
      if @heading_options[:heading_columns]
        @heading_columns = @heading_options[:heading_columns]
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
        para_options[:layout_lines]   = false
        @paragraphs << Paragraph.new(nil, para_options)    
      end
    end
    
    def layout_story
      @heading_options[:layout_expand]  = [:height]
      # @heading_options[:line_width]     = 2
      # @heading_options[:line_color]     = 'red'
      @heading_options[:width]          = @main_box.width_of_column(@heading_columns)
      @heading_options[:align_to_body_text]= true
      @heading_options[:layout_expand]  = nil
      @heading_options[:top_margin]     = 0
      @heading_options[:top_inset]      = 10
      @heading_options[:bottom_margin]  = 0
      @heading_options[:tottom_inset]   = 10
      @heading_options[:left_inset]     = 0
      @heading_options[:right_inset]    = 0
      @heading_options[:chapter_kind]   = "news_article"
      @heading_options[:current_style]  = NEWS_STYLES
      @main_box.floats << Heading.new(nil, @heading_options)
      relayout!
      @main_box.create_column_grid_rects 
      place_floats_to_text_box 
      @main_box.set_overlapping_grid_rect 
      @main_box.layout_items(@paragraphs)

    end
    
    def place_floats_to_text_box
      #TODO place other floats besides images
      @main_box.place_float_images(@images, @grid_width, @grid_height) if @images
      @main_box.layout_floats!
    end
  end
  
end

