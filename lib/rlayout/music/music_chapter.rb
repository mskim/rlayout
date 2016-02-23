

module RLayout
  class MusicChapter < Document
    attr_accessor :db_items, :heading, :source_path, :page_options
    attr_accessor :heading_options
    def initialize(options={}, &block)
      @page_options = options.dup
      options[:initial_page] = false
      super
      @source_path  = options[:source_path]
      @double_side  = true
      @heading_options = {}
      @heading_options[:title] = options[:title] if options[:title]
      @heading_options[:author] = options[:author] if options[:author]
      @page_count   = options.fetch(:page_count, 2)
      @toc_on       = options.fetch(:toc_on, false)
      @article_type = options.fetch(:article_type, "chapter") # magazin_article, news_article
      @page_options[:footer]        = true 
      @page_options[:header]        = true 
      @page_options[:grid_box]      = true
      @page_options[:column_count]  = 3
      @page_options[:column_layout_space]  = 10
      @page_options[:layout_space]  = 10
      @page_count.times do |i|
        @page_options[:page_number] = @starting_page_number + i
        Page.new(self, @page_options)
      end
      read_image_item
      layout_db_item(options={})
      self
    end
    
    # read .pdf or .jpg file
    def read_image_item
      @db_items = []
      Dir.glob("#{@source_path}/*{.pdf,.jpg}") do |f|
        @db_items << Image.new(nil, image_path: f, width: 300, height: 50)
      end
    end
    
    def layout_db_item(options={})
      page_index                = 0
      @first_page               = @pages[page_index]
      Heading.new(@first_page, @heading_options)
      # insert heading a at the top of graphics
      heading_object = @first_page.graphics.pop
      @first_page.graphics.unshift(heading_object)
      @first_page.relayout!
      @pages[0].main_box.layout_items(@db_items, options)
      while @db_items.length > 0
        page_index += 1
        if page_index >= @pages.length
          @page_options[:footer]      = true 
          @page_options[:header]      = true 
          @page_options[:grid_box]    = true
          @page_options[:column_count]= 4
          @page_options[:layout_space]  = 5
          @page_options[:page_number] = @starting_page_number + page_index
          Page.new(self, @page_options)          
        end
        @pages[page_index].main_box.layout_items(@db_items, options)
      end
      update_header_and_footer
      @first_page.main_box.graphics.first      
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
  
  # class MusicHeader < Header
  #   def initialize(parent_graphic, options={}, &block)
  #     super
  #     
  #     
  #     self
  #   end
  #   
  #   
  # end
end