# encoding: utf-8

# MagazineArticle should be able to support highly customizable designs.
# MagazineArticle works with given folder with story, layout.rb, and images
# layout.rb can define layout and styles
# if layout.rb doesn't exist in article folder, 
# default layout is used, "/Users/Shared/SoftwareLab/article_template/magazine.rb" is used.
# Image layout can be set using GIM
# Images can be stored in images folder by page and image size
# making almost every image in the article hand controlable.
 
# Page Count is usually fixed, default is 2

module RLayout

  class MagazineArticleMaker
    attr_accessor :article_path, :template, :story_path, :image_path
    attr_accessor :document, :style, :output_path, :starting_page_number
    attr_accessor :no_story
    def initialize(options={} ,&block)
      unless options[:article_path]
        puts "No article_path given !!!"
        return
      end
      @starting_page_number = options.fetch(:starting_page_number, 1)
      @article_path = options[:article_path]
      @story_path   = Dir.glob("#{@article_path}/*.{md,markdown}").first
      unless @story_path
        puts "No story_path !!!"
        @no_story = true
      end
      @template     = @article_path + "/layout.rb"
      $ProjectPath  = @article_path
      @style_path   = @article_path + "/style.rb"
      @output_path  = @article_path + "/output.pdf"
      unless File.exist?(@template)
        @template = "/Users/Shared/SoftwareLab/article_template/magazine.rb"
      end
      unless File.exist?(@style_path)
        @style_path   = "/Users/Shared/SoftwareLab/article_template/magazine_style.rb"        
      end
      @document       = eval(File.open(@template,'r'){|f| f.read})
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@template} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::Document)
        puts "Not a @document kind created !!!"
        return
      end   
      
      unless @no_story == true
        read_story
        layout_story
      end
      
      if @output_path
        if RUBY_ENGINE =="rubymotion"
          @document.save_pdf(@output_path)
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
      if @document.pages[0].has_heading?
        @document.pages[0].get_heading.set_heading_content(@heading)
        @document.pages[0].relayout!
      elsif @document.pages[0].main_box.floats.length == 0
        @document.pages[0].main_box.floats << Heading.new(nil, @heading)
      elsif @document.pages[0].main_box.has_heading?
        @document.pages[0].main_box.get_heading.set_heading_content(@heading)
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
        para_options[:article_type]   = @article_type
        para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:layout_lines]   = false
        @paragraphs << Paragraph.new(nil, para_options)
      end
    end

    def layout_story
      page_index                = 0
      @first_page               = @document.pages[0]
      @first_page.main_box.layout_floats!  
      @first_page.main_box.set_overlapping_grid_rect
      @first_page.main_box.layout_items(@paragraphs)
      page_index += 1
      # for magazine , do not add pages even if we have overflowing paragraphs
      while @paragraphs.length > 0 && page_index < @document.pages.length
        @document.pages[page_index].main_box.layout_items(@paragraphs)
        page_index += 1
      end
      update_header_and_footer
    end

    def next_chapter_starting_page_number
      @starting_page_number=1 if @starting_page_number.nil?
      @page_view_count = 0   if @page_view_count.nil?
      @starting_page_number + @page_view_count
    end

    def save_toc(path)

    end
    
    def update_header_and_footer
      header= {}
      header[:first_page_text]  = "| #{@book_title} |" if @book_title
      header[:left_page_text]   = "| #{@book_title} |" if @book_title
      header[:right_page_text]  = @title if @title

      footer= {}
      footer[:first_page_text]  = @book_title if @book_title
      footer[:left_page_text]   = @book_title if @book_title
      footer[:right_page_text]  = @title if @title
      options = {
        :header => header,
        :footer => footer,
      }
      @document.header_rule = header_rule
      @document.footer_rule = footer_rule
      @document.pages.each {|page| page.update_header_and_footer(options)}
    end
    
    def header_rule
      {
        :first_page_only  => true,
        :left_page        => false,
        :right_page       => false,
      }
    end

    def footer_rule
      h ={}
      h[:first_page]      = true
      h[:left_page]       = true
      h[:right_page]      = true
      h
    end
    
    def self.save_rakefile(path)
      rake_text  = <<-EOF.gsub(/^\s*/, "")
      task :default => :pdf

      md_files = FileList["**/*.md", "**/*.markdown"]
      source_files = FileList["**/*.md", "**/*.markdown", "**/layout.rb"]

      task :pdf => source_files.map {|source_file| File.dirname(source_file) + "/output.pdf" }

      source_files.each do |source_file|
        pdf_file = File.dirname(source_file) + "/output.pdf"
        file pdf_file => source_file do
          sh "/Applications/magazine.app/Contents/MacOS/magazine  #{File.dirname(source_file)}"
        end
      end

      task :force do
      	md_files.each do |md_file|
      		sh "/Applications/magazine.app/Contents/MacOS/magazine  #{File.dirname(md_file)}"
      	end
      end

      
      EOF
      File.open(path, 'w'){|f| f.write rake_text}
    end
  end

end
