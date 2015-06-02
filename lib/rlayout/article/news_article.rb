
module RLayout

  class NewsArticle < TextBox
    attr_accessor :story_path, :paragraphs, :heading, :images
    attr_accessor :output_path, :images_dir

    def initialize(parent_graphic, options={}, &block)
      @output_path            = options[:output_path] if options[:output_path]
      style_service           = RLayout::StyleService.shared_style_service
      style_service.current_style = NEWS_STYLES
      @current_style          = NEWS_STYLES
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
      options[:left_margin]   = 5 unless options[:left_margin]
      options[:top_margin]    = 5 unless options[:top_margin]
      options[:right_margin]  = 5 unless options[:right_margin]
      options[:bottom_margin] = 5 unless options[:bottom_margin]

      if options[:story_path]
        unless File.exist?(options[:story_path])
          puts "File #{options[:story_path]} does not exist!!!"
          return
        end
        @story_path   = options[:story_path]
        puts "@story_path:#{@story_path}"
        @images_dir   = File.dirname(@story_path) + "/images"
        options.merge! read_story
        puts "options:#{options}"
      elsif options[:story]
        @heading_options    = options[:story][:heading]
        @images     = options[:images]
        if @heading_options[:heading_columns]
          @heading_columns = HEADING_COLUMNS_TABLE[@heading_options[:heading_columns].to_i]
        end
        @paragraphs = []
        para_data_array = options[:story][:para_data_array] if options[:story][:para_data_array]
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
      @paragraphs         =[]
      make_paragraph(story[:paragraphs])
      options = {}
      @images             = story[:heading]['images']  if  story[:heading]['images']

      options[:grid_frame]         = story[:heading]['grid_frame']
      options[:grid_frame]         = eval(options[:grid_frame]) if options[:grid_frame].class == String
      options[:grid_base]          = [options[:grid_frame][2],options[:grid_frame][3]]
      options[:gutter]             = story[:heading]['gutter'] || 10
      options[:v_gutter]           = story[:heading]['gutter'] || 0
      options[:column_count]       = options[:grid_frame][2]
      options[:grid_size]          = story[:heading]['grid_size'] || [188.188571428571, 158.674166666667]
      options[:grid_size]          = eval(options[:grid_size]) if options[:grid_size].class == String
      options[:grid_width]         = options[:grid_size][0]
      options[:grid_height]        = options[:grid_size][1]
      options[:x]                  = 0
      options[:y]                  = 0
      options[:width]              = options[:grid_width] * options[:grid_frame][2] + (options[:grid_frame][2] - 1)*options[:gutter]
      options[:height]             = options[:grid_height] * options[:grid_frame][3]+ (options[:grid_frame][3] - 1)*options[:v_gutter]

      @heading_options    = story[:heading]
      if @heading_options['heading_columns']
        @heading_columns  = @heading_options['heading_columns'].to_i
      else
        @heading_columns  = HEADING_COLUMNS_TABLE[options[:grid_frame][2].to_i]
      end

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
      @heading_options[:width]          = width_of_columns(@heading_columns)
      @heading_options[:align_to_body_text]= true
      @heading_options[:layout_expand]  = nil
      @heading_options[:top_margin]     = 0
      @heading_options[:top_inset]      = 10
      @heading_options[:bottom_margin]  = 0
      @heading_options[:tottom_inset]   = 10
      @heading_options[:left_inset]     = 0
      @heading_options[:right_inset]    = 0
      @heading_options[:is_float]       = true
      Heading.new(self, @heading_options)
      relayout!
      create_column_grid_rects
      place_float_images(@images)
      layout_floats!
      set_overlapping_grid_rect
      layout_items(@paragraphs)
    end

  end

end
