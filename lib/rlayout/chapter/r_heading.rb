# What is Heading
# Heading is used in Articles and Chapters.
# Heading consists of title, subtile, quote, author

# We have two Heading handling classes, Heading and HeadingContainer
# Heading grows box in vertical direction, usually used in Chapter, and Article Heading.
# HeadingContainer is pre-designed template with fixed layout position
# It is used mostly in StudyAide Book Heading, and Newspaper Heading.

# Layout Heading
# 1. get heading box width from page by calling "drawing_area"
# 1. get the text height of each heading elements
# 1. create each element with expand=>[:width, :height]
# 1. set set layout_length as height, so that their height is proportional to height
# 1. set Heading expand =>:width
# 1. adjust height to height sum of heading elements
# when we call relayout! it will have grown to sum of its parts and layed outed out with height propotionally adjusted as each ones height.

# PageScript Verbs
#  number
#  title
#  subtitle
#  quote
#  author

# Todo
# 2016 9 20
# HeadingContainer
#  support pre-made pdf image as options[:image]
#  support background pdf image as options[:background]

# 2014 12 17
# 1. Use TextRun and TextLine instead of Text
# 2. Create Banner Class



module RLayout

  # heading width is set to parents's layout_size[width].
  # heading height is set to content height sum initially.
  # And the height is re-adjusted by the parent.
  # Each heading element layout_length is set to it's height
  # This way, parent can shrink or expand heading and maintain each elements's height propotion.
  # heading height should be multiles of body text height
  class RHeading < Container
    attr_accessor :number_object, :title_object, :subtitle_object, :quote_object, :author_object
    attr_accessor :align_to_body_text, :output_path
    def initialize(options={}, &block)
      # options[:stroke_width] = 1.0
      # options[:stroke_width] = 1
      super
      @x                  = 0
      @y                  = 0
      @output_path        = options[:output_path]
      @layout_alignment   = options[:v_alignment]
      @align_to_body_text = options[:align_to_body_text] if options[:align_to_body_text]
      @layout_space       = 3
      if options[:width]
        @width = options[:width]
      elsif @parent
        @width = @parent.layout_size[0]
      else
        @width = 600
      end
      @top_inset      = options.fetch(:top_inset,0)
      @bottom_inset   = options.fetch(:top_inset,0)
      @left_inset     = options.fetch(:left_inset,5)
      @right_inset    = options.fetch(:right_inset,5)
      @top_margin     = options.fetch(:top_margin,0)
      @bottom_margin  = options.fetch(:bottom_margin,0)
      @layout_align   = 'center'
      @align_to_body_text = options[:align_to_body_text] || true
      @layout_expand  = options.fetch(:layout_expand,[:width, :height])
      @line_type=0
      #TODO
      options.delete(:stroke_width)
      set_heading_content(options)
      if block
        instance_eval(&block)
      end

      if @output_path
        save_pdf_with_ruby(@output_path)
      end

      self
    end

    def transform_keys_to_symbols(value)
      return value if not value.is_a?(Hash)
      hash = value.inject({}){|memo,(k,v)| memo[k.to_sym] = transform_keys_to_symbols(v); memo}
      return hash
    end

    def set_heading_content(options)
      options = transform_keys_to_symbols(options)
      if options[:image_only]
        # place image, change size, width, or height as instructed
        # This is when pre-made Heading is provided as pdf file using other app.
        return
      end
      if options[:background]
        # place image in the background, change size, width, or height as instructed
      end

      @y_position = 20
      if options[:title]
        t = @title_object = title(options[:title])
        @title_object.y = @y_position
        @y_position += t.height
      else
        h = {x:0, y: @y}
        @title_object = title('Untitled')
        @title_object.y = @y_position
        @y_position += t.height
      end

      if options[:subtitle]
        t = @subtitle_object = subtitle(options[:subtitle])
        @subtitle_object.y = @y_position + 10
        @y_position += t.height
      end

      if options[:quote]
        @quote_object = quote(options[:quote])
        @quote_object.y = @y_position + 10
      end

      # relayout!

      self
    end

    def align_vertically
      hight_sum = @graphics.map{|g| g.height}.reduce(:+)
      top_position = (height - hight_sum)/2
      @graphics.each do |g|
        g.y += top_position
      end
    end

    # create container with template and replace variavle data to get our heaing
    def self.variable_heading(options)
      unless options[:keys] && options[:data]
        puts "No keys or no data options found...."
        return
      end
      variables_hash = {}
      variables_hash[:keys] = options.fetch(:keys, {})
      variables_hash[:data] = options.fetch(:data, {})
      hash = nil
      if options[:template]
        unless File.exists?(options[:template])
          puts "Can't find template file #{options[:template]} "
          return
        end
        template_library_path= options[:template] + "/layout.yml"
        hash=YAML::load_file(template_library_path)
        hash[:path] = options[:template]
        options.delete(:template)
        hash.merge(options)
      # This is where we pass read document hash, so we don't have to read template file, for batch processing with same template
      elsif options[:template_hash]
        # flatten template_hash
        hash = options[:template_hash].dup
        options.delete(:template_hash)
        hash.merge(options)
      end
      heading=Heading.new(hash)
      heading.replace_tagged_graphic(variables_hash)
      heading.replace_variables(variables_hash)
      heading
    end

    def self.news_page_heading(options={})
      publication = options.fetch(:publication, "B2")
      path    = "/Users/shared/SoftwareLab/heading/news_page/#{publication}.rlib"
      unless File.exists?(path)
        puts "Can't find #{path} !!!"
        return
      end
      heading = Container.open_library(path)
      heading.replace_variables(options)
      heading
    end

    def self.make_headline(options={})
      headline= Heading.new(options)
      if options[:output_path]
        headline.save_pdf(options[:output_path])
      end
    end

    ######## PageScript verbes
    def title(string, options={})
      atts                        = {}
      atts[:style_name]           = 'title'
      atts[:text_string]          = string
      atts[:width]                = @width
      atts[:text_alignment]            = 'center'
      atts[:text_fit_type]        = 'adjust_box_height'
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      # atts                        = options.merge(atts)
      atts[:parent]               = self
      # @title_object               = Text.new(atts)
      @title_object               = TitleText.new(atts)
      @title_object.layout_length = @title_object.height
      @title_object
    end

    def subtitle(string, options={})
      atts                          = {}
      atts[:style_name]             = 'subtitle'
      atts[:text_string]            = string
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      # atts                          = options.merge(atts)
      atts[:parent]                 = self
      @subtitle_object              = TitleText.new(atts)
      @subtitle_object.layout_expand= [:width]
      @subtitle_object.layout_length= @subtitle_object.height
      @subtitle_object
    end

    def quote(string, options={})
      atts                          = {}
      atts[:style_name]             = 'quote'
      atts[:text_string]            = string
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      # atts                          = options.merge(atts)
      atts[:parent]                 = self
      @quote_object               = TitleText.new(atts)
      @quote_object.layout_expand = [:width]
      @quote_object.layout_length = @quote_object.height
      @quote_object
    end

    def author(string, options={})
      atts                          = {}
      atts[:style_name]             = 'author'
      atts[:text_string]            = string
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:right_indent]           = 10
      atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      # atts                          = options.merge(atts)
      atts[:parent]                 = self
      @author_object                = TitleText.new(atts)
      @author_object.layout_expand  = [:width]
      @author_object.layout_length  = @author_object.height
      @author_object
    end

    def background(image_path, options={})
      options[:loca_image] = image_path
      init_image(options)
    end
  end

end
