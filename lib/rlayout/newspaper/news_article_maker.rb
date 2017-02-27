# encoding: utf-8

# NewsArticleMaker.
# NewsArticleMaker works with given folder with story.md, layout.rb, and images
# layout.rb defines the layout of the article.
# if layout.rb doesn't exist in article folder,
# default layout is used, "/Users/Shared/SoftwareLab/article_template/news_article.rb" is used.

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
      @svg_path  = @article_path + "/output.svg"
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
        @news_article_box.save_svg(@svg_path)

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
        if  box_heading.class == RLayout::NewsArticleHeading
          box_heading.set_heading_content(@heading)
        else
          puts "+++++++++++ no heading"
        end
      end
      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        para_options[:para_string]    = para[:para_string]
        para_options[:article_type]   = "news_article"
        para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:layout_lines]   = false
        @paragraphs << NewsParagraph.new(para_options)
      end
    end

    def layout_story
      # @news_article_box.layout_floats!
      @news_article_box.adjust_overlapping_columns
      @news_article_box.layout_items(@paragraphs)

    end
  end
end
