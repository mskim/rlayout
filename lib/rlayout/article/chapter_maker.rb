# encoding: utf-8

# ChapterMaker merges Story and Document.
# Document template can come from variaous Document Template file.
# The key is to make it flexible, loading custom designs at run time.
# ChapterMaker loads template from file, which includes custom Styles .
# Story can come from couple of sources, markdown or URL(blog)
# Document Template can be evaled

module RLayout

  class ChapterMaker
    attr_accessor :template, :story_path
    attr_accessor :document

    def initialize(options={} ,&block)
      @template = options.fetch(:template, "/Users/Shared/SoftwareLab/article_template/chapter.rb")
      unless options[:story_path]
        puts "No story_path !!!"
        return
      else
        @story_path = options[:story_path]
        unless File.exist?(@story_path)
          puts "No story_path doen't exist !!!"
          return
        end
      end
      @document = eval(File.open(@template,'r'){|f| f.read})
      
      unless @document
        puts "No @document created !!!"
        return
      end
      read_story
      layout_story
      
      if options[:output_path]
        @document.save_pdf(options[:output_path])
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
      @heading[:layout_expand]  = [:width, :height]
      # if @article_type == "magazine_article"
      #   #make it a flost for magazine
      #   unless @document.main_box
      #     # add main_box
      #   end
      #   @heading[:width]        = @first_page.main_box.heading_width
      #   @heading[:align_to_body_text]= true
      #   @heading[:layout_expand]= nil
      #   @heading[:top_margin]   = 10
      #   @heading[:top_inset]    = 50
      #   @heading[:bottom_margin]= 10
      #   @heading[:tottom_inset] = 50
      #   @heading[:left_inset]   = 0
      #   @heading[:right_inset]  = 0
      #   @heading[:article_type]  = "magazine_article"
      #   @first_page.main_box.floats << Heading.new(nil, @heading)
      #   # @first_page.main_box.relayout_floats!
      # else # chapter
        # insert heading at the top of first page
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

  end

end
