
module RLayout

  class NewsArticle < Page
    attr_accessor :story_path, :paragraphs #:heading, :images
    attr_accessor :output_path, 

    def initialize(parent_graphic, options={})
      @output_path            = options[:output_path] if options[:output_path]
      style_service           = RLayout::StyleService.shared_style_service
      style_service.current_style = NEWS_STYLES
      @current_style          = NEWS_STYLES
      options[:x]             = options.fetch(:x, 0)
      options[:y]             = options.fetch(:y, 0)
      if options[:grid_frame]
        if options[:grid_frame].class == String
          options[:grid_frame] = eval(options[:grid_frame])
        end
        if options[:grid_width].class == String
          options[:grid_width] = eval(options[:grid_width])
        end
        if options[:grid_height].class == String
          options[:grid_height] = eval(options[:grid_height])
        end
        @heading_columns = HEADING_COLUMNS_TABLE[options[:grid_frame][2].to_i]
        # @heading_columns = options[:grid_frame][2]
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
        @story_path   = options[:story_path]
        options_from_reading_story_file = read_story
        options.merge!(options_from_reading_story_file)
      elsif options[:story]
        @heading_options    = options[:story][:heading]
        @images     = options[:images]
        if @heading_options[:heading_columns]
          @heading_columns = HEADING_COLUMNS_TABLE[@heading_options[:heading_columns].to_i]
          # @heading_columns = @heading_options[:heading_columns].to_i
        end
        @paragraphs = []
        # if we have body in para_data_array format
        para_data_array = options[:story][:para_data_array] if options[:story][:para_data_array]
        # if we have body in body_markdown format
        # I should use the para_data_array if possible
        # Markdown should be converted to para_data_array by fromt-end using Nokogiri or Kramdown
        # I do not prefer using Cocoa xml parsing .
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
      story               = Story.markdown2para_data(@story_path)
      @heading_options    = story[:heading]
      @images             = story['images']  if  story['images']
      @grid_frame         = story[:heading]['grid_frame']
      @gutter             = story[:heading]['gutter'] || 10
      @v_gutter           = story[:heading]['gutter'] || 0
      @grid_frame         = eval(@grid_frame) if @grid_frame.class == String
      @column_count       = @grid_frame[2]
      @grid_size          = story[:heading]['grid_size'] || [188.188571428571, 158.674166666667]
      @grid_size          = eval(@grid_size) if @grid_size.class == String
      @grid_width         = @grid_size[0]
      @grid_height        = @grid_size[1]


      if @heading_options['heading_columns']
        @heading_columns  = @heading_options['heading_columns'].to_i
      else
        @heading_columns  = HEADING_COLUMNS_TABLE[@grid_frame[2].to_i]
      end
      @paragraphs         =[]
      make_paragraph(story[:paragraphs])
      options = {}
      options[:grid_frame]  = @grid_frame
      options[:grid_width]  = @grid_width
      options[:gutter]      = @gutter
      options[:v_gutter]    = @v_gutter
      options[:width]       = @grid_frame[2]*@grid_width + (@grid_frame[2] - 1)*@gutter
      options[:height]      = @grid_frame[3]*@grid_height + ((@grid_frame[3] - 1)*@v_gutter)
      options[:column_count]= @column_count
      options
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

    def layout_story
      @heading_options[:layout_expand]  = [:height]
      @heading_options[:width]          = @main_box.width_of_columns(@heading_columns)
      @heading_options[:align_to_body_text]= true
      @heading_options[:layout_expand]  = nil
      @heading_options[:top_margin]     = 0
      @heading_options[:top_inset]      = 10
      @heading_options[:bottom_margin]  = 0
      @heading_options[:tottom_inset]   = 10
      @heading_options[:left_inset]     = 0
      @heading_options[:right_inset]    = 0
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
