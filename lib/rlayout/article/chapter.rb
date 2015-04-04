# encoding: utf-8

# There are three types of articles, chapter, magazine_article, and news article/
# chapter:
#     1. page numbers can grow to arbitrary pages
#     1. Usually heading is not floating elelment, just graphics layer

# magazine_article:
#     1. page number is usually fixed to 1, 2, 3, or 4 as specified
#     1. flats are used for heading, image, side_box, quotes, leading
#     1. non-uniform heading width and height is used
#         example: three column layout can have two column heading
#
# news_article:
#     1. single page based
#     1. floats are used for heading
#     1. width and height of layout is based on parent's grid
#     1. parent grid_width, and grid_height is used to calculate frame
#     1. column number is same as the grid_width
#     1. non-uniform heading width and height is used

module RLayout

  # Chapter
  # given Story path
  # create two initial pages with TextBox, header, footer, side_bar(optional)
  #  read the story
  #  set @heading and @paragraphs
  #  call @pages.first.main_box.layout_story(:heading=>@heading, :paragraphs=> @paragraphs)
  #    main_box takes heading data and creates chapter front page heading
  #    main_box take @paragraphs data out of Array and inserts it into text_box.
  #  if the changed paragraphs length is 0, which means all the paragraphs have been layed out
  #    we are done.
  #  else means we have leftover paragraphs, go to next page, if no page, create one with TextBox
  #    after first page :heading is nil, and the paragraphs are the rest of the leftover paragraphs form the initial page
  #    call main_box.layout_story agoin with (:heading=>nil, :paragraphs=> @paragraphs)
  #  keep going until we have no more leftover paragraphs.

  class Chapter < Document
    attr_accessor :story_path, :heading, :paragraphs, :current_style
    attr_accessor :toc_on, :chapter_kind, :column_count

    def initialize(options={} ,&block)
      super
      @bottom_margin      = 100
      @double_side        = true
      @page_count         = options.fetch(:page_count, 2)
      @column_count       = options.fetch(:column_count, 1)
      @toc_on             = options.fetch(:toc_on, false)
      @chapter_kind       = options.fetch(:chapter_kind, "chapter") # magazin_article, news_article
      @current_style      = CHAPTER_STYLES
      @heading_columns    = @current_style["heading_columns"][@column_count-1]
      options[:footer]    = true
      options[:header]    = true
      options[:text_box]  = true
      options[:heading_columns] = @heading_columns unless options[:heading_columns]
      @page_count.times do |i|
        options[:page_number] = @starting_page_number + i
        Page.new(self, options)
      end
      if @story_path = options[:story_path]
        read_story
        layout_story
      end
      if options[:save_path]
        save_pdf(options[:save_path])
      end
      self
    end

    def read_story
      unless File.exists?(@story_path)
        puts "Can not find file #{@story_path}!!!!"
        return {}
      end

      story = Story.markdown2para_data(@story_path)
      @heading    = story[:heading] || {}
      @title      = @heading[:title] || "Untitled"

      @paragraphs =[]
      story[:paragraphs].each do |para|
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
        #TODO should not pass the Hash, just name of it and make it look it up at paragraph level
        para_options[:current_style]  = @current_style
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
        @heading[:align_to_body_text]= true
        @heading[:layout_expand]= nil
        @heading[:top_margin]   = 10
        @heading[:top_inset]    = 50
        @heading[:bottom_margin]= 10
        @heading[:tottom_inset] = 50
        @heading[:left_inset]   = 0
        @heading[:right_inset]  = 0
        @heading[:chapter_kind]  = "magazine_article"
        @heading[:current_style] = MAGAZINE_STYLES
        @first_page.main_box.floats << Heading.new(nil, @heading)
        # @first_page.main_box.relayout_floats!
      elsif  @chapter_kind == "news_article"
        #make it a flost for news_article
        @heading[:width]        = @first_page.main_box.heading_width
        @heading[:layout_expand]= nil
        @heading[:top_margin]   = 0
        @heading[:top_inset]    = 0
        @heading[:bottom_margin]= 0
        @heading[:tottom_inset] = 0
        @heading[:left_inset]   = 0
        @heading[:right_inset]  = 0
        @first_page.main_box.floats << Heading.new(nil, @heading)
        @first_page.relayout!
        # @first_page.main_box.relayout_floats!
      else
        @heading[:chapter_kind]  = "chapter"
        @heading[:current_style] = CHAPTER_STYLES
        # make head a as one of graphics
        heading_object = Heading.new(nil, @heading)
        @first_page.graphics.unshift(heading_object)
        heading_object.parent_graphic = @first_page
      end
      @first_page.relayout!
      @first_page.main_box.create_column_grid_rects
      @first_page.main_box.set_overlapping_grid_rect
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
          p=Page.new(self, options)
          p.relayout!
          p.main_box.create_column_grid_rects
        end

        @pages[page_index].main_box.layout_items(@paragraphs)
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
      @pages.each {|page| page.update_header_and_footer(options)}
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
