# encoding: utf-8


module RLayout
  # There are three types of articles, chapter, magazine_article, and news article/
  # chapter: 
  #     1. page numbers can grow into arbitrary pages
  #     1. Usually no floating elelment, just graphics layer

  # magazine_article: 
  #     1. page number is usually fixed to 1, 2, 3, or 4
  #     1. flats are used for heading, image, side_box, quotes, leading
  # 
  # news_article: 
  #     1. single page based
  #     1. floats are used for heading
  #     1. width and height of layout is based on parent's grid 
  #     1. non-uniform heading width and height is used
  
  
  # Chapter
  # create two initial pages with TextBox, header, footer, side_bar(optional)
  # given Story path
  #  read the story
  #  set @heading and @paragraphs
  #  call @pages.first.main_box.layout_story(:heading=>@heading, :paragraphs=> @paragraphs)
  #    main_box takes heading data and creates chapter front page heading
  #    main_box take @paragraphs data out of Array and inserts it into text_box.
  #  if the changed paragraphs length is 0, which means all the paragraphs have been layed out
  #    we are done.
  #  else means we have some left over paragraphs, go to next page, if no page, create one with TextBox
  #    after first page :heading is nil, and the paragraphs are the rest of the left overs
  #    call main_box.layout_story agoin with (:heading=>nil, :paragraphs=> @paragraphs)
  #  keep going until we have no more leftover paragraphs.
  
  class Chapter < Document
    attr_accessor :story_path, :heading, :paragraphs, :style_service
    attr_accessor :toc_on, :chapter_kind, :column_count
    
    def initialize(options={})
      super
      @bottom_margin      = 100
      @double_side        = true
      @page_count         = options.fetch(:page_count, 2)
      @column_count       = options.fetch(:column_count, 1)
      @toc_on             = options.fetch(:toc_on, false)
      @chapter_kind       = options.fetch(:chapter_kind, "chapter") # magazin_article, news_article
      @style_service      = StyleService.shared_style_service(:chapter_kind=>@chapter_kind)
      options[:footer]    = true 
      options[:header]    = true 
      options[:text_box]  = true
      @page_count.times do |i|
        options[:page_number] = @starting_page_number + i
        Page.new(self, options)
      end
      if options[:story_path]
        @story_path = options[:story_path]
        read_story
        layout_story
      end
      self
    end
    
    def read_story
      story       = Story.from_meta_markdown(@story_path)
      @heading    = story.heading
      @title      = @heading[:title]
      #TODO read it form book_config.rb?
      @book_title = @heading[:book_title]
      # @style_service ||= StyleService.new(:chapter_kind=>@chapter_kind)
      @paragraphs =[]
      story.paragraphs.each do |para| 
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
        para_options[:chapter_kind]   = @chapter_kind
        para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:layout_lines]   = false
        
        @paragraphs << Paragraph.new(nil, para_options)
      end
    end
    
    def layout_story
      page_index                = 0
      @first_page               = @pages[page_index]
      @heading[:layout_expand]  = [:width, :height]
      # @heading[:line_width]     = 2
      # @heading[:line_color]     = 'red'
      # this is where we make heading as graphics or float
      if @chapter_kind == "magazine_article"
        #make it a flost for magazine
        @heading[:width]        = @first_page.main_box.heading_width
        @heading[:layout_expand]= nil
        @heading[:top_margin]   = 10
        @heading[:top_inset]    = 50
        @heading[:bottom_margin]= 10
        @heading[:tottom_inset] = 50
        @heading[:left_inset]   = 0
        @heading[:right_inset]  = 0
        @heading[:chapter_kind]  = "magazine_article"
        @first_page.main_box.floats << Heading.new(nil, @heading)
        # @first_page.main_box.relayout_floats!
      # elsif  @chapter_kind == "news_article"
      #   #make it a flost for news_article
      #   @heading[:width]        = @first_page.main_box.heading_width
      #   @heading[:layout_expand]= nil
      #   @heading[:top_margin]   = 0
      #   @heading[:top_inset]    = 0
      #   @heading[:bottom_margin]= 0
      #   @heading[:tottom_inset] = 0
      #   @heading[:left_inset]   = 0
      #   @heading[:right_inset]  = 0
      #   @first_page.main_box.floats << Heading.new(nil, @heading)
      #   @first_page.relayout!
      #   # @first_page.main_box.relayout_floats!
      #   @first_page.main_box.set_non_overlapping_frame_for_chidren_graphics        
      else 
        @heading[:chapter_kind]  = "chapter"
        # make head a as one of graphics
        heading_object = Heading.new(nil, @heading)
        @first_page.graphics.unshift(heading_object)
        heading_object.parent_graphic = @first_page
      end
      @first_page.relayout!
      @first_page.main_box.set_non_overlapping_frame_for_chidren_graphics
      @first_page.main_box.layout_items(@paragraphs)
      while @paragraphs.length > 0
        page_index += 1
        if page_index >= @pages.length
          options ={}
          options[:footer]      = true 
          options[:header]      = true 
          options[:text_box]    = true
          options[:page_number] = @starting_page_number + page_index
          options[:column_count]= @column_count
          Page.new(self, options)
        end
        @pages[page_index].main_box.layout_items(@paragraphs)
      end
      update_header_and_footer
    end
    
    def book_node
      BookNode.new("chapter", @title, @starting_page_number, @page_view_count)
    end
    
    def next_chapter_starting_page_number
      @starting_page_number=1 if @starting_page_number.nil?
      @page_view_count = 0   if @page_view_count.nil?
      @starting_page_number + @page_view_count
    end
    
    def save_toc(path)
      
    end
    
    def defaults
      {
        portrait: true,
        double_side: false,
        starts_left: true,
        width: 419.53,
        height: 595.28,
        left_margin: 50,
        top_margin: 50,
        right_margin: 50,
        bottom_margin: 100,
      }
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
      @pages.each {|page| page.update_header_and_footer(options)}
    end
        
    def header_rule
      h={
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