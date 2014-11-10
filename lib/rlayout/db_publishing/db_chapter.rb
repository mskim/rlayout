
module RLayout
  class DBChapter < Document
    attr_accessor :db_items, :heading, :source_path, :page_options
    def initialize(options={}, &block)
      @page_options = options.dup
      super
      @source_path  = options[:source_path]
      @double_side  = true
      @page_count   = options.fetch(:page_count, 2)
      @toc_on       = options.fetch(:toc_on, false)
      @chapter_kind = options.fetch(:chapter_kind, "chapter") # magazin_article, news_article
      @page_options[:footer]        = true 
      @page_options[:header]        = true 
      @page_options[:object_box]    = true
      @page_options[:column_count]  = 4
      @page_options[:column_layout_space]  = 5
      @page_options[:item_space]    = 3
      @page_count.times do |i|
        @page_options[:page_number] = @starting_page_number + i
        p = Page.new(self, @page_options)
      end
      read_pdf_item
      layout_db_item
      self
    end
    
    def read_pdf_item
      @db_items = []
      Dir.glob("#{@source_path}/**.pdf") do |f|
        @db_items << Image.new(nil, image_path: f)
      end
    end
    
    def layout_db_item
      page_index                = 0
      @first_page               = @pages[page_index]
      # @heading[:layout_expand]  = [:width, :height]
      # this is where we make heading as graphics or float
      # if @chapter_kind == "magazine_article" || @chapter_kind == "news_article"
      #   #make it a flost for magazine, news_article
      #   @first_page.main_box.floats << Heading.new(nil, @heading)
      #   @first_page.relayout!
      #   @first_page.main_box.relayout_floats!
      # else 
      #   # make head a as one of graphics
      #   heading_object = Heading.new(nil, @heading)
      #   @first_page.graphics.unshift(heading_object)
      #   heading_object.parent_graphic = @first_page
      #   @first_page.relayout!
      # end
      
      @first_page.main_box.layout_items(@db_items)
      while @db_items.length > 0
        page_index += 1
        if page_index >= @pages.length
          @page_options[:footer]      = true 
          @page_options[:header]      = true 
          @page_options[:object_box]  = true
          @page_options[:column_count]= 4
          @page_options[:item_space]  = 5
          @page_options[:page_number] = @starting_page_number + page_index
          p= Page.new(self, @page_options)
          puts "p.width:#{p.width}"
          
        end
        @pages[page_index].main_box.layout_items(@db_items)
      end
      update_header_and_footer
      
      column = @first_page.main_box.graphics.first      
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