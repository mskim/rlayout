# encoding: utf-8

# NewsArticleMaker should be able to support highly customizable designs.
# NewsArticleMaker works with given folder with story, layout.rb, and images
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
    attr_accessor :news_article_box, :style, :output_path, :project_path

    def initialize(options={} ,&block)
      @story_path = options[:story_path]
      if options[:story_path]
        @story_path = options[:story_path]
        unless File.exist?(@story_path)
          puts "No story_path doen't exist !!!"
          return
        end
        @article_path = File.dirname(@story_path)
      elsif options[:article_path]
        @article_path = options[:article_path]
        unless File.directory?(@article_path)
          puts "article_path doesn't exit !!!"
          return
        end
        @story_path = Dir.glob("#{@article_path}/*[.md, .markdown]").first
        unless File.exist?(@story_path)
          puts "story_path doesn't exit !!!"
          return
        end
      end

      $ProjectPath  = @article_path
      if options[:image_path]
        @image_path = options[:image_path]
      else
        @image_path = @article_path + "/images"
      end

      if options[:output_path]
        @output_path = options[:output_path]
      else
        @output_path  = @article_path + "/output.pdf"
      end

      if options[:template_path] && File.exist?(options[:template_path])
        @template_path = options[:template_path]
      else
        @template_path = Dir.glob("#{@article_path}/*.{rb,script,pgscript}").first
      end
      unless @template_path
        @template_path = options.fetch(:template_path, "/Users/Shared/SoftwareLab/article_template/news_style.rb")
      end
      template = File.open(@template_path,'r'){|f| f.read}
      @news_article_box       = eval(template)
      if @news_article_box.is_a?(SyntaxError)
        puts "SyntaxError in #{@template_path} !!!!"
        return
      end
      read_story
      layout_story
      if RUBY_ENGINE =="rubymotion"
        @news_article_box.save_pdf(@output_path, :jpg=>true)
      else
        puts "save_pdf in ruby"
      end
      self
    end

    def read_story
      @story      = Story.new(@story_path).markdown2para_data
      @heading    = @story[:heading] || {}
      @title      = @heading[:title] || "Untitled"

      if @heading
        box_heading = nil
        box_heading = @news_article_box.get_heading
        if  box_heading.class == RLayout::Heading
          box_heading.set_heading_content(@heading)
        else
          puts "+++++++++++ box_heading.class:#{box_heading.class}"
        end
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
          @paragraphs << Image.new(para_options)
          next
        end
        para_options[:para_string]    = para[:para_string]
        para_options[:article_type]   = "news_article"
        para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:layout_lines]   = false
        @paragraphs << Paragraph.new(para_options)
      end
    end

    def layout_story
      @news_article_box.layout_floats!
      @news_article_box.set_overlapping_grid_rect
      @news_article_box.layout_items(@paragraphs)
    end
  end
end
