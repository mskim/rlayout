
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
  
  # heading width is set to parents's layout_area[width]. 
  # heading height is set to content height sum initially. 
  # And the height is re-adjusted by the parent.
  # Each heading element layout_length is set to it's height
  # This way, parent can shrink or expand heading and maintain each elements's height propotion. 

  class Heading < Container
    attr_accessor :title_text, :subtitle_text, :leading_text, :author_text
    attr_accessor :style_service
    
    def initialize(parent_graphic, options={}, &block)
      if options[:style_service] 
        @style_service = options[:style_service]
      else
        @style_service ||= StyleService.new(options)
      end
      super   
      @klass = "Heading"   
      @layout_space = 2
      if options[:width]
        @width = options[:width]
      elsif @parent_graphic
        @width = @parent_graphic.layout_area[0]
      else
        @width = 600
      end
      
      @top_inset      = 5
      @bottom_inset   = 5
      @left_inset     = 10
      @right_inset    = 10
      
      @layout_expand = [:width]
      
      width = @width - @left_inset - @right_inset
      
      if options[:title]
        @title_text = title(options[:title], options)
      end

      if options[:subtitle]        
        @subtitle_text = subtitle(options[:subtitle], options)
      end

      if options[:leading]
        @leading_text = leading(options[:leading], options)
      end

      if options[:author]
        @author_text = author(options[:author], options)
      end

      @line_type=0
      @line_width=1
      @line_color="lightGray"
      height_sum = 0      
      height_sum +=@title_text.height    unless @title_text.nil?
      height_sum +=@subtitle_text.height unless @subtitle_text.nil?
      height_sum +=@leading_text.height  unless @leading_text.nil?
      height_sum +=@author_text.height   unless @author_text.nil?
      @height = height_sum + graphics_space_sum + @top_inset + @bottom_inset
      relayout!
      
      self
    end
    

    def self.news_article_heading(options={})
      atts          = @style_service.style_for_markup("title", options)
      atts[:string] = options[:title]
      height        = GTextRecord.text_height_with_atts(width, atts)
      height_sum    += height
      @title        = Text.new(self, :ns_atts_array=>[atts], :line_with=>5, :text_fit=>FIT_FONT_SIZE)         
      @title.layout_expand=[:width, :height]
      @title.layout_length  = height
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
    
    #TODO
    # def change_width_and_adjust_height(new_width, options={})
    # 
    # end
    
    ######## PageScript verbes
    def title(string, options={})
      atts  = @style_service.style_for_markup("title", options)
      atts[:text_string] = string
      atts[:width] = @width
      @title_text = Text.new(self, atts)
      @title_text.layout_expand  = [:width]
      @title_text.layout_length  = atts[:text_size]
      @title_text.height  = atts[:text_size]*1.2
      @title_text
    end
    
    def subtitle(string, options={})
      atts  = @style_service.style_for_markup("subtitle", options)
      atts[:text_string] = string
      atts[:width] = @width
      @subtitle_text = Text.new(self, atts)
      @subtitle_text.layout_expand  = [:width]
      @subtitle_text.layout_length  = atts[:text_size]
      @subtitle_text.height  = atts[:text_size]*1.2      
      @subtitle_text
    end
    
    def leading(string, options={})
      atts  = @style_service.style_for_markup("leading", options)
      atts[:text_string] = string
      atts[:width] = @width
      @leading_text = Text.new(self, atts)
      @leading_text.layout_expand  = [:width]
      @leading_text.layout_length  = atts[:text_size]
      @leading_text.height  = atts[:text_size]*1.2      
      @leading_text
    end
    
    def author(string, options={})
      atts  = @style_service.style_for_markup("author", options)
      atts[:text_string] = string
      atts[:width] = @width
      @author_text = Text.new(self, atts)
      @author_text.layout_expand  = [:width]
      @author_text.layout_length  = atts[:text_size]
      @author_text.height  = atts[:text_size]*1.2      
      @author_text
    end
  end

    
    
  class Banner < Heading
    attr_accessor :place, :when, :organization, :image
    attr_accessor :category, :width, :height, :direction
    
  end
  
end