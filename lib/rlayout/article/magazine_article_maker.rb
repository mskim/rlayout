# encoding: utf-8

# MagazineArticleMaker should be able to support highly customizable designs.
# MagazineArticleMaker works with given folder with story, layout.rb, and images
# layout.rb defines layout and styles
# if layout.rb doesn't exist in article folder, 
# default layout is used, "/Users/Shared/SoftwareLab/article_template/magazine.rb" is used.
# Image layout can be set using GIM
# Images can be stored in images folder by page and image size
# making image in the article controlable.
 
# Page Count is usually fixed for magazine, default is 2

module RLayout

  class MagazineArticleMaker
    attr_accessor :article_path, :template, :story_path, :images_dir, :tables_dir
    attr_accessor :document, :style, :starting_page_number, :no_story
    attr_accessor :output_path
    
    def initialize(options={} ,&block)
      puts "2016 6 17"
      $publication_type = "magazine"
      @article_path = options[:article_path] || options[:project_path]
      @starting_page_number = options.fetch(:starting_page_number, 1)
      @article_path = options[:article_path]
      @story_path   = Dir.glob("#{@article_path}/*.{md,markdown}").first
      if !@story_path && @article_path
        puts "No story_path !!!"
        return
      end
      @no_story     = true unless @story_path
      @template     = Dir.glob("#{@article_path}/*.{rb,pgscript}").first
      $ProjectPath  = @article_path
      @style_path   = @article_path + "/style.rb"
      @output_path  = @article_path + "/output.pdf"
      if options[:images_dir]
        @images_dir = options[:images_dir]
      else
        @images_dir = @article_path + "/images"
      end
      if options[:tables_dir]
        @tables_dir = @article_path + "/tables"
      else
        @tables_dir = @article_path + "/tables"
      end
      
      unless File.exist?(@template)
        @template   = "/Users/Shared/SoftwareLab/article_template/magazine.rb"
      end
      @document     = eval(File.open(@template,'r'){|f| f.read})
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
          output_options = {:preview=>true}
          @document.save_pdf(@output_path, output_options)
        else
          puts "RUBY_ENGINE == ruby"
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
        @document.pages[0].main_box.floats << Heading.new(@heading)
      elsif @document.pages[0].main_box.has_heading?
        @document.pages[0].main_box.get_heading.set_heading_content(@heading)
      end
      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        if para[:markup] == 'img'
          # support ![] syntex
          source = para[:local_image]
          para_options[:caption]        = para[:caption]
          para_options[:bottom_margin]  = 10
          para_options[:bottom_inset]   = 10
          para_options[:image_path] = @images_dir + "/#{source}"
          @paragraphs << Image.new(para_options)
          next
        elsif para[:markup] == 'image'
          source = para[:local_image]
          # para_options[:caption]        = para[:caption]
          para_options[:bottom_margin]  = 10
          para_options[:bottom_inset]   = 10
          para_options[:image_path] = @images_dir + "/#{source}"
          @paragraphs << Image.new(para_options)
          next
        elsif para[:markup] == 'table'
          para[:layout_expand]  = [:width]
          if para[:csv_path]
            para[:csv_path] = @tables_dir + "/#{para[:csv_path]}"
          end
          @paragraphs << Table.new(para)
          next
        end
        para_options[:para_string]    = para[:string]
        para_options[:article_type]   = @article_type
        para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:layout_lines]   = false
        @paragraphs << Paragraph.new(para_options)
      end
    end

    def layout_story
      page_index                = 0
      @first_page               = @document.pages[0]
      @first_page.main_box.layout_floats! 
      # puts "number of floats:#{@first_page.main_box.floats.length}"
      # @first_page.main_box.floats.each do |float|
      #   puts "++++ "
      #   float.puts_frame
      # end
      @first_page.main_box.set_overlapping_grid_rect
      @first_page.main_box.update_column_areas
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
