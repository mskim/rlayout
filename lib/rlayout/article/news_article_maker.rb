# encoding: utf-8

# NewsArticle should be able to support highly customizable designs.
# NewsArticle works with given folder with story, layout.rb, and images
# layout.rb can define layout and styles
# if layout.rb doesn't exist in article folder, 
# default layout is used, "/Users/Shared/SoftwareLab/article_template/news_article.rb" is used.
# Image layout can be set using GIM
# Images can be stored in images folder by page and image size
# making almost every image in the article hand controlable.
 
# Page Count is usually fixed, default is 2

module RLayout

  class NewsArticleMaker
    attr_accessor :article_path, :template, :story_path, :image_path
    attr_accessor :news_article_box, :style, :output_path

    def initialize(options={} ,&block)
      unless options[:article_path]
        puts "No article_path given !!!"
        return
      end
      @starting_page_number = options.fetch(:starting_page_number, 1)
      @article_path = options[:article_path]
      @story_path = Dir.glob("#{@article_path}/*.{md,markdown}").first
      unless @story_path
        puts "No story_path !!!"
        return
      end
      @template     = Dir.glob("#{@article_path}/layout.{rb,script,erb,pgscript}").first
      $ProjectPath  = @article_path
      @style_path   = @article_path + "/style.rb"
      @output_path  = @article_path + "/output.pdf"
      unless File.exist?(@template)
        self.make_news_article_layout
        # @template = "/Users/Shared/SoftwareLab/article_template/news_article.rb"
      end
      unless File.exist?(@style_path)
        @style_path   = "/Users/Shared/SoftwareLab/article_template/news_article_style.rb"        
      end
      @news_article_box       = eval(File.open(@template,'r'){|f| f.read})
      unless @news_article_box
        puts "No @news_article_box created !!!"
        return
      end
      current_style  = eval(File.open(@style_path, 'r'){|f| f.read})
      if current_style.is_a?(SyntaxError)
        puts "SyntaxError in #{@style_path} !!!!"
        return
      end
      RLayout::StyleService.shared_style_service.current_style = current_style
      read_story
      layout_story
      
      if @output_path
        if RUBY_ENGINE =="rubymotion"
          @news_article_box.save_pdf(@output_path)
        else
          puts 
        end
      end
      self
    end
    
    def read_story
      unless File.exists?(@story_path)
        puts "Can not find file #{@story_path}!!!!"
        return {}
      end
      @story = Story.markdown2para_data(@story_path)
      @heading    = @story[:heading] || {}
      @title      = @heading[:title] || "Untitled"
      if @news_article_box.has_heading?
        @news_article_box.get_heading.set_heading_content(@heading)
      elsif @heading !={}
        @news_article_box.heading(@heading)
      end
      
      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        if para[:markup] == 'img'
          source = para[:image_path]
          para_options[:caption]        = para[:caption]
          para_options[:bottom_margin]  = 10
          para_options[:bottom_inset]   = 10
          full_image_path = File.dirname(@story_path) + "/#{source}"
          para_options[:image_path] = full_image_path
          @paragraphs << Image.new(nil, para_options)
          next
        end
        para_options[:text_string]    = para[:string]
        para_options[:article_type]   = "news_article"
        para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:layout_lines]   = false
        @paragraphs << Paragraph.new(nil, para_options)
      end
    end

    def layout_story
      @news_article_box.layout_floats!  
      @news_article_box.set_overlapping_grid_rect
      @news_article_box.layout_items(@paragraphs)
    end
  end
end
