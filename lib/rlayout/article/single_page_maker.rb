# encoding: utf-8

# SinglePageMaker should be able to support highly customizable designs.
# SinglePageMaker works with given folder with text.md, layout.rb, and images
# layout.rb can define layout and styles
# if layout.rb is not given or doesn't exist in article folder, return 
# Images location are pre-defined in layout.rb. 
# Images are stored in images folder 
# This is used for PhotoPage and AdBox 

module RLayout

  class SinglePageMaker
    attr_accessor :project_path, :template, :story_path, :image_path
    attr_accessor :page, :text_box, :style, :output_path

    def initialize(project_path, options={} ,&block)
      unless File.directory?(project_path)
        puts "No project_path folder exists !!!"
        return
      end
      @project_path = project_path
      @story_path   = Dir.glob("#{@project_path}/*.{md,markdown}").first
      if options[:input_path]
        @template     = options[:input_path]
      else
        @template     = Dir.glob("#{@project_path}/*.rb").first
      end
      if options[:output_path]
        @output_path  = options[:output_path]
      else
        @output_path  = @project_path + "/output.pdf"
      end
      @style_path   = @project_path + "/style.rb"
      $ProjectPath  = @project_path
      unless @template
        puts "No @template fount !!!"
        return
      end
      @page         = eval(File.open(@template,'r'){|f| f.read})
      unless @page
        puts "No @page created !!!"
        return
      end
        
      if current_style.is_a?(SyntaxError)
        puts "SyntaxError in #{@style_path} !!!!"
        return
      end
      # puts "current_style:#{current_style}"
      if @story_path && File.exist?(@story_path)
        if @page.kind_of?(RLayout::TextBox)
          @text_box = @page
        else
          @text_box = @page.first_text_box
        end
        if @text_box
          read_story
          layout_story  
        end        
      else
        puts "no story !!!"
      end
      
      if @output_path
        if RUBY_ENGINE =="rubymotion"
          @page.save_pdf(@output_path)
        else
          # puts "should save output"
        end
      end
      self
    end
    
    def read_story
      unless File.exist?(@story_path)
        puts "Can not find file #{@story_path}!!!!"
        return {}
      end

      @story = Story.new(@story_path).markdown2para_data
      @heading    = @story[:heading] || {}
      @title      = @heading[:title] || "Untitled"
      if @heading !={}
        if @text_box.floats.length == 0
          @text_box.floats << Heading.new(@heading)
        end
      elsif @text_box.has_heading?
        @text_box.get_heading.set_heading_content(@heading)
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
        para_options[:para_string]    = para[:string]
        para_options[:article_type]   = "news_article"
        para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:layout_lines]   = false
        @paragraphs << Paragraph.new(para_options)
      end
    end

    def layout_story
      @text_box.layout_floats!  
      @text_box.set_overlapping_grid_rect
      @text_box.layout_items(@paragraphs)
    end
    
  end

end
