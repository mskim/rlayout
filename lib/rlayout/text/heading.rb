
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
# 1. set set unit_length as height, so that their height is proportional to height
# 1. set Heading expand =>:width


module RLayout
  
  # heading height is set to content height sum initially. 
  # And the height is re-adjusted by the parent.
  # Each heading element unit_length is set to it's height
  # This way, parent can shrink or expand heading and maintain each elements's height propotion. 

  class Heading < Container
    attr_accessor :title_text, :subtitle_text, :leading_text, :author_text
    attr_accessor :style_service
    
    def initialize(parent_graphic, options={}, &block)
      super      
      @layout_space = 2
      if options[:width]
        @width = options[:width]
      else
        @width = @parent_graphic.width if @parent_graphic
      end
      
      @left           = 0
      @top            = 0
      @right          = 0
      @bottom         = 0
      @top_inset      = 5
      @bottom_inset   = 5
      @left_inset     = 10
      @right_inset    = 10
      
      @layout_expand = :width
      if options[:style_service] 
        @style_service = options[:style_service]
      else
        #TODO
        # @style_service ||= StyleService.new(options)
      end
            
      
      width = @width - @left_inset - @right_inset
      height_sum = 0
      if options[:title]
        atts          = @style_service.style_for_markup("title", options)
        atts[:string] = options[:title]
        height        = GTextRecord.text_height_with_atts(width, atts)
        height_sum    += height
        @title        = Text.new(self, :ns_atts_array=>[atts], :line_with=>5, :text_fit=>FIT_FONT_SIZE)         
        @title.layout_expand=[:width, :height]
        @title.unit_length  = height
      end

      if options[:subtitle]        
        atts = @style_service.style_for_markup("subtitle", options)        
        atts[:string] = options[:subtitle]
        height        = GTextRecord.text_height_with_atts(width, atts)
        height_sum    += height
        @subtitle     = Text.new(self, :ns_atts_array=>[atts], :text_fit=>FIT_FONT_SIZE)         
        @title.layout_expand=[:width, :height]
        @subtitle.unit_lengthunit_lengthunit_length  = height
      end

      if options[:leading]
        atts = @style_service.style_for_markup("leading", options)
        atts[:string] = options[:leading]
        height        = GTextRecord.text_height_with_atts(width, atts)
        height_sum    += height
        @leading      = Text.new(self, :ns_atts_array=>[atts], :text_fit=>FIT_FONT_SIZE)         
        @leading.layout_expand=[:width, :height]
        @leading.unit_length  = height
      end

      if options[:author]
        atts = @style_service.style_for_markup("author", options)
        atts[:string] = options[:author]
        height        = GTextRecord.text_height_with_atts(width, atts)
        height_sum    += height
        @author      = Text.new(self, :ns_atts_array=>[atts], :text_fit=>FIT_FONT_SIZE)         
        @author.layout_expand=[:width, :height]
        @author.unit_length  = height
      end

      @height = height_sum + graphics_space_sum
      @line_type=2
      @line_width=1
      @line_color="lightGray"
      
      if block
        instance_eval(&block)
      end

      self
    end
    

    def self.news_article_heading(options={})
      atts          = @style_service.style_for_markup("title", options)
      atts[:string] = options[:title]
      height        = GTextRecord.text_height_with_atts(width, atts)
      height_sum    += height
      @title        = Text.new(self, :ns_atts_array=>[atts], :line_with=>5, :text_fit=>FIT_FONT_SIZE)         
      @title.layout_expand=[:width, :height]
      @title.unit_length  = height
      news_setting = {
        :title => "Newspaper sample title",
        :author => "Min Soo Kim",
        :category => "news"
      }
      
      Heading.new(nil, news_setting)
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
    
    # title, subtile, author, quote
    def self.chapter_heading(options={})
      
    end
    
    # titel, subtile, author, quote
    def self.magazine_heading(options={})
      
    end
    
    # title, phone, 
    def self.mart_flier_heading(options={})
      
    end
    
    def self.make_headline(options={})
      headline= Heading.new(nil, options)
      if options[:output_path]
        headline.save_pdf(options[:output_path])
      end
    end
    
    ######## PageScript verbes
    
    def title(string)
      @title_text = Text.new(self, text_string: string, text_markup: "title")
    end
    
    def subtitle(string)
      @subtitle_text = Text.new(self, text_string: string, text_markup: "subtitle")
      
    end
    
    def author(string)
      @author_text = Text.new(self, text_string: string, text_markup: "author")
      
    end
    
    def leading(string)
      @leading_text = Text.new(self, text_string: string, text_markup: "leading")
    end
  end

    
    
  class Banner < Heading
    attr_accessor :place, :when, :organization, :image
    attr_accessor :category, :width, :height, :direction
    
  end
  
end