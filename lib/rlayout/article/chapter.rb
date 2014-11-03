# encoding: utf-8

require File.dirname(__FILE__) + '/story_box'
require File.dirname(__FILE__) + '/story'
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
  # create two initial pages with StoryBox, header, footer, side_bar(optional)
  # given Story path
  #  read the story
  #  set @heading and @paragraphs
  #  call @pages.first.story_box_object.layout_story(:heading=>@heading, :paragraphs=> @paragraphs)
  #    story_box_object takes heading data and creates chapter front page heading
  #    story_box_object take @paragraphs data out of Array and inserts it into story_box.
  #  if the changed paragraphs length is 0, which means all the paragraphs have been layed out
  #    we are done.
  #  else means we have some left over paragraphs, go to next page, if no page, create one with StoryBox
  #    after first page :heading is nil, and the paragraphs are the rest of the left overs
  #    call story_box_object.layout_story agoin with (:heading=>nil, :paragraphs=> @paragraphs)
  #  keep going until we have no more leftover paragraphs.
  
  class Chapter < Document
    attr_accessor :story_path, :heading, :paragraphs
    attr_accessor :toc_on, :chapter_kind
    
    def initialize(options={})
      super
      @bottom_margin = 100
      @double_side  = true
      @page_count   = options.fetch(:page_count, 2)
      @toc_on       = options.fetch(:toc_on, false)
      @chapter_kind = options.fetch(:chapter_kind, "chapter") # magazin_article, news_article
      options[:footer]    = true 
      options[:header]    = true 
      options[:story_box] = true
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
      
      @style_service ||= StyleService.new()
      @paragraphs =[]
      story.paragraphs.each do |para| 
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:text_string]    = para[:string]
        para_options[:layout_expand]  = [:width]
        para_options[:text_fit]       = FIT_FONT_SIZE
        # para_options[:line_width]       = 1
        # para_options[:line_color]       = 'black'
        @paragraphs << Paragraph.new(nil, para_options)
      end
    end
    
    def layout_story
      page_index                = 0
      @first_page               = @pages[page_index]
      @heading[:layout_expand]  = [:width, :height]
      # @heading[:line_width]  = 2
      # @heading[:line_color]  = 'black'
      # this is where we make heading as graphics or float
      # for book chapter, we make it as graphic
      # for magazine, news_article , we make it as float
      if @chapter_kind == "magazine_article" || @chapter_kind == "news_article"
        #make it a flost for magazine, news_article
        @first_page.story_box_object.floats << Heading.new(nil, @heading)
        @first_page.relayout!
        @first_page.story_box_object.relayout_floats!
      else 
        # make head a as one of graphics
        heading_object = Heading.new(nil, @heading)
        @first_page.graphics.unshift(heading_object)
        heading_object.parent_graphic = @first_page
        @first_page.relayout!
      end
      
      @first_page.story_box_object.layout_story(:heading=>nil, :paragraphs=>@paragraphs)
      while @paragraphs.length > 0
        page_index += 1
        if page_index >= @pages.length
          options ={}
          options[:footer]     = true 
          options[:header]     = true 
          options[:story_box]  = true
          options[:page_number]= @starting_page_number + page_index
          Page.new(self, options)
        end
        @pages[page_index].story_box_object.layout_story(:heading=>nil, :paragraphs=>@paragraphs)
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