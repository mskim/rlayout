
# PageScript Verbs
#  title
#  subtitle
#  leading
#  author


# Todo
# 2013 12 17
# 1. Use TextRun and TextLine instead of Text
# 2. Create Banner Class

# What is Heading
# Heading consists of title, subtile, leading, author
# Heading is used in Article.

# Layout Heading
# 1. get heading box width from page by calling "drawing_area"
# 1. get the text height of each heading elements
# 1. create each element with expand=>[:width, :height]
# 1. set set layout_length as height, so that their height is proportional to height
# 1. set Heading expand =>:width

module RLayout

  # heading width is set to parents's layout_size[width].
  # heading height is set to content height sum initially.
  # And the height is re-adjusted by the parent.
  # Each heading element layout_length is set to it's height
  # This way, parent can shrink or expand heading and maintain each elements's height propotion.
  # heading height should be multiles of body text height
  class Heading < Container
    attr_accessor :title_object, :subtitle_object, :leading_object, :author_object
    attr_accessor :align_to_body_text
    def initialize(parent_graphic, options={}, &block)
      super      
      @klass              = "Heading"
      @current_style      = RLayout::StyleService.shared_style_service.current_style
      @align_to_body_text = options[:align_to_body_text] if options[:align_to_body_text]
      @layout_space       = 2
      if options[:width]
        @width = options[:width]
      elsif @parent_graphic
        @width = @parent_graphic.layout_size[0]
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
      set_heading_content(options)
      self
    end
    
    def set_heading_content(options)
      if options[:title]
        @title_object = title(options[:title], options)
      elsif options["title"]
        @title_object = title(options["title"], options)
      end
      if options[:subtitle]
        @subtitle_object = subtitle(options[:subtitle], options)
      elsif options["subtitle"]
        @subtitle_object = subtitle(options["subtitle"], options)
      end
      if options[:leading]
        @leading_object = leading(options[:leading], options)
      elsif options["leading"]
        @leading_object = leading(options["leading"], options)
      end
      if options[:author]
        @author_object = author(options[:author], options)
      elsif options["author"]
        @author_object = author(options["author"], options)
      end
      
      height_sum = 0
      height_sum +=@title_object.height    unless @title_object.nil?
      height_sum +=@subtitle_object.height unless @subtitle_object.nil?
      height_sum +=@leading_object.height  unless @leading_object.nil?
      height_sum +=@author_object.height   unless @author_object.nil?
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
      heading=Heading.new(nil, hash)
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
      headline= Heading.new(nil, options)
      if options[:output_path]
        headline.save_pdf(options[:output_path])
      end
    end

    ######## PageScript verbes
    def title(string, options={})
      atts                        = @current_style["title"]
      atts[:text_string]          = string
      atts[:width]                = @width
      atts[:text_fit_type]        = 'adjust_box_height'
      atts[:layout_expand]        = [:width]
      @title_object               = Text.new(self, atts)
      @title_object.layout_length = @title_object.height
      @title_object
    end

    def subtitle(string, options={})
      atts                          = @current_style["subtitle"]
      atts[:text_string]            = string
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      @subtitle_object              = Text.new(self, atts)
      @subtitle_object.layout_expand= [:width]
      @subtitle_object.layout_length= @subtitle_object.height
      @subtitle_object
    end

    def leading(string, options={})
      atts                          = @current_style["leading"]
      atts[:text_string]            = string
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      @leading_object               = Text.new(self, atts)
      @leading_object.layout_expand = [:width]
      @leading_object.layout_length = @leading_object.height
      @leading_object
    end

    def author(string, options={})
      atts                          = @current_style["author"]
      atts[:text_string]            = string
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:right_indent]           = 10
      @author_object                = Text.new(self, atts)
      @author_object.layout_expand  = [:width]
      @author_object.layout_length  = @author_object.height
      @author_object
    end
    
    def background(image_path, options={})
      options[:loca_image] = image_path
      init_image(options) 
    end
  end



  class Banner < Heading
    attr_accessor :place, :when, :organization, :image
    attr_accessor :category, :width, :height, :direction
  end

end
