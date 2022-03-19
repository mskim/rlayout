# What is Heading
# Heading is used in Articles and Chapters.
# Heading consists of title, subtile, leading, author

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
#  leading
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
  class Heading < Container
    attr_accessor :number_object, :title_object, :subtitle_object, :leading_object, :author_object
    attr_accessor :align_to_body_text
    def initialize(options={}, &block)
      options[:fill_color] = 'red'
      super
      case $publication_type
      when "magazine"
        @current_style = RLayout::StyleService.shared_style_service.magazine_style
      when "chapter"
        @current_style = RLayout::StyleService.shared_style_service.chapter_style
      when "news"
        @current_style = RLayout::StyleService.shared_style_service.news_style
      else
        @current_style = RLayout::StyleService.shared_style_service.current_style
      end

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
      @layout_expand  = options.fetch(:layout_expand,[:width])
      @line_type=0
      #TODO
      options.delete(:stroke_width)
      set_heading_content(options)
      if block
        instance_eval(&block)
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

      # if options[:number]
      #   @number_object = title(options[:title], options)
      # elsif options["number"]
      #   @number_object = title(options["number"], options)
      # end

      if options[:title]
        @title_object = title(options[:title], options)
      end
      if options[:subtitle]
        @subtitle_object = subtitle(options[:subtitle], options)
      end
      if options[:leading]
        @leading_object = leading(options[:leading], options)
      end
      if options[:author]
        @author_object = author(options[:author], options)
      end

      height_sum = 0
      height_sum +=@title_object.height    unless @title_object.nil?
      height_sum += 5
      height_sum +=@subtitle_object.height unless @subtitle_object.nil?
      height_sum += 5
      height_sum +=@leading_object.height  unless @leading_object.nil?
      height_sum += 5
      height_sum +=@author_object.height   unless @author_object.nil?
      height_sum += 5
      # @height = height_sum + graphics_space_sum + @top_inset + @bottom_inset + @top_margin + @bottom_margin
      @height = height_sum
      if @align_to_body_text
        mutiple           = (@height/body_height).to_i
        mutiple_height    = mutiple*body_height
        room              = mutiple_height - @height
        @top_inset        +=  room/2
        @bottom_inset     +=  room/2
        @height           = mutiple_height
      end
      relayout!
      self
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
        unless File.exist?(options[:template])
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
      unless File.exist?(path)
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
      atts                        = @current_style["title"]
      atts[:style_name]           = 'title'
      atts[:text_string]          = string
      atts[:width]                = @width
      atts[:text_fit_type]        = 'adjust_box_height'
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts                        = options.merge(atts)
      atts[:parent]               = self
      @title_object               = RLayout::TitleText.new(atts)
      @title_object.layout_length = @title_object.height
      @title_object
    end

    def subtitle(string, options={})
      atts                          = @current_style["subtitle"]
      atts[:style_name]             = 'subtitle'
      atts[:text_string]            = string
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      atts                          = options.merge(atts)
      atts[:parent]                 = self
      @subtitle_object              = RLayout::TitleText.new(atts)
      @subtitle_object.layout_expand= [:width]
      @subtitle_object.layout_length= @subtitle_object.height
      @subtitle_object
    end

    def leading(string, options={})
      atts                          = @current_style["leading"]
      atts[:style_name]             = 'leading'
      atts[:text_string]            = string
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      atts                          = options.merge(atts)
      atts[:parent]                 = self
      @leading_object               = RLayout::TitleText.new(atts)
      @leading_object.layout_expand = [:width]
      @leading_object.layout_length = @leading_object.height
      @leading_object
    end

    def author(string, options={})
      atts                          = @current_style["author"]
      atts[:style_name]             = 'author'
      atts[:text_string]            = string
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:right_indent]           = 10
      atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      atts                          = options.merge(atts)
      atts[:parent]                 = self
      @author_object                = RLayout::TitleText.new(atts)
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
