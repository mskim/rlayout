# encoding: utf-8

# ChapterMaker merges Story and Document.
# Story can come from couple of sources, markdown, adoc, or html(URL blog)
# Story can be adoc, markdown, or html format.
# Stories are first converted to para_data format and saved as yaml files. 

# ChapterMaker loads template from file, which includes custom Styles .

# How to place images in long document?
# There are two ways of placing images in the long document.
# One way is to embed image markup in the text. 
# Image markup can container layout information, such as grid_frame, size, position attributes.
# Or another ways is to use pre-desinged layout.rb with images boxes.
# Or the third way is to combine above two, automate it first, auto generate layout.rb file and let designer manually adjust it,
# For book chapters, first method is used.
# For short documents, such as magazine article, second choice is used.

# mark up image with # ## ##
# # image: filename: "1.jpg", grid_frame: [0,0,1,1], bleed: true
# ## image: filename: "1.jpg" grid_frame: [0,0,1,1]
# ### image: filename: "1.jpg"

# each indicate the side of image
# How to place image caption?
# have a file that has same name but extension of .caption?
# add p write after the # image tag, this should be the caption?

# Add Image bleeding support

# Inserting Pre-Made PDF Pages in the middle of the pages. 

module RLayout

  class ChapterMaker
    attr_accessor :project_path, :template, :story_path
    attr_accessor :document, :output_path

    def initialize(options={} ,&block)
      @template = options.fetch(:template, "/Users/Shared/SoftwareLab/article_template/chapter.rb")
      unless options[:story_path]
        puts "No story_path !!!"
        return
      else
        @story_path = options[:story_path]
        @project_path = File.dirname(@story_path)
        $ProjectPath  = @project_path
        
        unless File.exist?(@story_path)
          puts "No story_path doen't exist !!!"
          return
        end
        if options[:output_path]
          @output_path = options[:output_path]
        else
          ext = File.extname(@story_path)
          @output_path = @story_path.gsub(ext, ".pdf")
        end
      end
      @document = eval(File.open(@template,'r'){|f| f.read})
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@template} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::Document)
        puts "Not a @document kind created !!!"
        return
      end
      read_story
      layout_story      
      @document.save_pdf(@output_path) unless options[:no_output]
      
      self
    end
        
    def read_story
      unless File.exists?(@story_path)
        puts "Can not find file #{@story_path}!!!!"
        return {}
      end
      @story      = Story.markdown2para_data(@story_path)
      @heading    = @story[:heading] || {}
      @title      = @heading[:title] || "Untitled"
      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        if para[:markup] == 'img'
          para_options.merge!(eval(para[:string]))
          # source = para[:image_path]
          # para_options[:caption]        = para[:caption]
          # para_options[:bottom_margin]  = 10
          # para_options[:bottom_inset]   = 10
          # full_image_path = File.dirname(@story_path) + "/#{source}"
          # para_options[:image_path] = full_image_path
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
      @heading[:layout_expand]  = [:width, :height]
      heading_object = Heading.new(nil, @heading)
      @first_page.graphics.unshift(heading_object)
      heading_object.parent_graphic = @first_page
      # end
      @first_page.relayout!
      @document.pages[1].relayout!
      @first_page.main_box.create_column_grid_rects
      @first_page.main_box.set_overlapping_grid_rect
      @first_page.main_box.layout_items(@paragraphs)
      while @paragraphs.length > 0
        page_index += 1
        if page_index >= @document.pages.length
          options ={}
          options[:footer]      = true
          options[:header]      = true
          options[:text_box]    = true
          options[:page_number] = @starting_page_number + page_index
          options[:column_count]= @column_count
          p=Page.new(self, options)
          p.relayout!
          p.main_box.create_column_grid_rects
        end

        @document.pages[page_index].main_box.layout_items(@paragraphs)
        
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
    # generate layout.rb file with script in each page
    # for manual image adjusting
    def generate_layout
      @page_content = ""
      layout_text = <<-EOF
      RLayout::Document.new do
        #{@page_content}
      EOF
      page_text = <<-EOF
        #page: #{@page_number}
        page do
          main_text do
            #{@image_layout}
          end
        end
      EOF
      @document.pages.each_with_index do |page, i|
        @page_number = i + 1
        @image_layout = ""
        page.floats.each do |float|
          @image_layout += float.to_script
        end
        @page_content += page_text
      end
      layout_file = layout_text
      File.open(layout_path, 'w'){|f| f.write layout_file}
    end
  end

end