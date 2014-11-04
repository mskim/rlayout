
module RLayout
  class DBChapter < Document
    attr_accessor :db_info, :db_items, :heading
    def initialize(options={}, &block)
      super
      @double_side  = true
      @page_count   = options.fetch(:page_count, 2)
      @toc_on       = options.fetch(:toc_on, false)
      @chapter_kind = options.fetch(:chapter_kind, "chapter") # magazin_article, news_article
      options[:footer]    = true 
      options[:header]    = true 
      options[:story_box] = true
      # options[:column_count] = 4
      
      @page_count.times do |i|
        options[:page_number] = @starting_page_number + i
        Page.new(self, options)
      end
            

      # if options[:db_info]
        @db_info = options[:db_info]
        read_db_item
        layout_db_item
      # end
      self
    end
    
    # def read_story

    def read_db_item
      # db_source       = DBSource.fetch(@db_info)
      # @heading    = db_source.heading
      # @title      = @heading[:title]
      # @book_title = @heading[:book_title]
      # 
      # @style_service ||= StyleService.new()
      # @db_items = []
      
      # db_source.items.each do |item_info| 
      #   @db_items << AdBox.new(nil, item_info)
      # end
      @db_items = AdBox.samples_of(200)
    end
    
    def layout_db_item
      page_index                = 0
      @first_page               = @pages[page_index]
      # @heading[:layout_expand]  = [:width, :height]
      # this is where we make heading as graphics or float
      # if @chapter_kind == "magazine_article" || @chapter_kind == "news_article"
      #   #make it a flost for magazine, news_article
      #   @first_page.story_box_object.floats << Heading.new(nil, @heading)
      #   @first_page.relayout!
      #   @first_page.story_box_object.relayout_floats!
      # else 
      #   # make head a as one of graphics
      #   heading_object = Heading.new(nil, @heading)
      #   @first_page.graphics.unshift(heading_object)
      #   heading_object.parent_graphic = @first_page
      #   @first_page.relayout!
      # end
      
      puts "+++++++++ @db_items.length:#{@db_items.length}"
      @first_page.story_box_object.layout_story(:heading=>nil, :paragraphs=>@db_items)
      while @db_items.length > 0
        page_index += 1
        if page_index >= @pages.length
          options ={}
          options[:footer]     = true 
          options[:header]     = true 
          options[:story_box]  = true
          options[:page_number]= @starting_page_number + page_index
          Page.new(self, options)
        end
        @pages[page_index].story_box_object.layout_story(:heading=>nil, :paragraphs=>@db_items)
      end
      update_header_and_footer
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