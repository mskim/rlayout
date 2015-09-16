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
      @template     = @article_path + "/layout.rb"
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
      if @news_article_box.floats.length == 0
        @news_article_box.floats << Heading.new(nil, @heading)
      elsif @news_article_box.has_heading?
        @news_article_box.get_heading.set_heading_content(@heading)
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
        
    def self.read_story_config(section_config_path, story_index)
        config = YAML::load(File.open(section_config_path, 'r'){|f| f.read})
        # YamlKit in Rubymotion saves true as 1 and reads as 1.0
        story_frame_index = story_index.to_i
        if config['has_heading'] == true || config['has_heading'] == 1.0
          story_frame_index += 1
        end
        options = {}
        options[:grid_frame]         = config['story_frames'][story_frame_index]
        options[:grid_frame]         = eval(options[:grid_frame]) if options[:grid_frame].class == String
        options[:grid_frame]         = options[:grid_frame].map {|e| e.to_i}
        options[:grid_base]          = [options[:grid_frame][2],options[:grid_frame][3]]
        options[:gutter]             = config['gutter'] || 10
        options[:v_gutter]           = config['gutter'] || 0
        options[:column_count]       = options[:grid_frame][2]
        options[:grid_width]         = config['grid_size'][0]
        options[:grid_height]        = config['grid_size'][1]
        options[:x]                  = 0
        options[:y]                  = 0
        options[:width]              = options[:grid_width] * options[:grid_frame][2] + (options[:grid_frame][2] - 1)*options[:gutter]
        options[:height]             = options[:grid_height] * options[:grid_frame][3]+ (options[:grid_frame][3] - 1)*options[:v_gutter]
        options      
    end
    
    def self.make_layout(article_path)
      require 'erb'
      unless File.exist?(article_path)
        puts "no article_path #{article_path} found !!!"
        return
      end
      template_path     = "/Users/Shared/SoftwareLab/article_template/news_article.rb.erb"
      unless File.exist?(template_path)
        puts "no template_path #{template_path} found !!!"
        return
      end
      section_path  = File.dirname(article_path)
      story_index   = File.basename(article_path,".md").split(".").first
      images        = Dir.glob("#{article_path}/images/*.{jpg,pdf,tiff}")
      @story_options = self.read_story_config(section_path + "/config.yml", story_index)
      # make image text
      @image_text = ""
      images.each_with_index do |image, i|
        @image_text += "  float_image(:local_image=>\"#{File.basename(image)}\", :grid_frame=>[0,#{i},1,1])\n"
      end
      layout_path = article_path + "/layout.rb"
      template_text = File.open(template_path, 'r'){|f| f.read}
      erb = ERB.new(template_text)
      File.open(layout_path, 'w'){|f| f.write erb.result(binding)}
    end
  end

end
