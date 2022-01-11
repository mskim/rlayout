# encoding: utf-8

module RLayout

  class RDocument
    attr_accessor :title, :document_path, :paper_size, :width, :height
    attr_accessor :pages, :document_view, :starting_page
    attr_accessor :toc_elements
    attr_reader :left_margin, :top_margin, :right_margin, :bottom_margin, :gutter
    attr_accessor :jpg, :preview, :column_count, :row_count, :column_width, :layout_style
    attr_accessor :heading_height_type, :body_line_count, :body_line_height
    attr_reader :max_page_number, :page_count
    attr_accessor :fixed_page_document
    attr_reader :column_grid, :row_grid
    # page_type is used to add differnt types of pages in a document
    # example Toc can create Doc with TocPages
    attr_reader :page_type, :toc_data
    def initialize(options={}, &block)
      if options[:paper_size] && SIZES[options[:paper_size]]
        @paper_size      = options[:paper_size]
        @width          = SIZES[options[:paper_size]][0]
        @height         = SIZES[options[:paper_size]][1]
      elsif options[:width] && options[:height] 
        @width          = options[:width]
        @height         = options[:height]
      else
        @paper_size      = "A4"
        @width          = 595.28
        @height         = 841.89
      end
      @page_type        = options[:page_type]
      @toc_data         = options[:toc_data]
      @fixed_page_document = false
      @starting_page    = options[:starting_page]   || 1
      @max_page_number  = options[:max_page_number] || 999
      if options[:body_line_count]
        @body_line_count  = options[:body_line_count] || 40
      else
        @body_line_count  = 40 if @paper_size == "A4"
        @body_line_count  = 25 if @paper_size == "A5"
        @body_line_count  = 25 if @paper_size == "16절" || @paper_size == "197x272" || @paper_size == "197X272"
      end
      @left_margin      = options[:left_margin]     || 110
      @top_margin       = options[:top_margin]      || 30
      @right_margin     = options[:right_margin]    || 110
      @bottom_margin    = options[:bottom_margin]   || 110
      @column_count     = options[:column_count]    || 1
      @row_count        = options[:row_count]       || 6
      @gutter           = options[:gutter]          || 20
      unless @body_line_height
        @body_line_height   = (@height - @top_margin - @bottom_margin)/@body_line_count
      end
      @column_width = (@width - @left_margin - @right_margin - @gutter*(@column_count - 1))/@column_count
      @pages            = []
      @page_count       = options[:page_count] || 1
      @page_float_layout = options[:page_float_layout]
      @page_count.times do |i|
        add_new_page(page_index: i)
      end
      if block
        instance_eval(&block)
      end
      self
    end

    def log
      log = ""
      @pages.each do |page|
        log += page.log
      end
      log
    end

    def page_number(page)
      @starting_page + pages.index(page)
    end

    def fixed_page_document?
      @fixed_page_document 
    end

    def next_text_line(page)
      if @pages.last == page
        nil
      else
        page_index = @pages.index(page)
        @pages[(page_index + 1)..-1].each do |page|
          next_page_text_line = @pages[page_index + 1].first_text_line
          return next_page_text_line if next_page_text_line
        end
      end
      nil
    end

    def images_folder
      @document_path + "/images"
    end

    def tables_folder
      @document_path + "/tables"
    end

    def save_story_page_by_page(pages_path)
      FileUtils.mkdir_p(pages_path) unless File.exist?(pages_path)
      @pages.each_with_index do |p, i|
        page_story_path = pages_path + "/#{i+1}_story.md"
        p.save_page_story(page_story_path)
      end
    end

    def first_line
      @pages.first.graphics.first
    end

    # return first page with text_line and the text_line
    def first_page_with_text_line
      @pages.each do |page|
        text_line = page.first_text_line
        return page, text_line if text_line
      end
    end

    def first_text_line
      @pages.each do |page|
        text_line = page.first_text_line
        return text_line if text_line
      end
    end

    def layout_rect
      [@left_margin, @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin]
    end

    # create new page and return first line of new page
    def add_new_page(options={})
      if @page_type && (@page_type == "toc_page" || @page_type == "cover_page")
        h                 = {}
        h[:parent]        = self
        h[:width]         = @width
        h[:height]        = @height
        h[:page_number]   = @pages.length + 1
        h[:toc_data]      = @toc_data
        new_page          = TocPage.new(h)
      else
        h                 = {}
        h[:parent]        = self
        h[:width]         = @width
        h[:height]        = @height
        h[:page_number]   = @pages.length + @starting_page
        h[:float_layout]  += page_float_layout[options[:page_index]] if @page_float_layout
        previous_line = @pages.last.last_line if @pages.length > 0 && @pages.last.last_line
        new_page = RPage.new(h)
        new_page_first_line = new_page.first_text_line
        previous_line.next_line = new_page_first_line if previous_line
        new_page_first_line
      end
    end

    def next_page(page)
      index = pages.index(page)
      new_index = index + 1
      if new_index < max_page_number 
        new_p = pages[new_index]
        if new_p
          new_p.first_text_line
        else
          add_new_page
        end
      end
    end


    def save_pdf(path, options={})
      save_pdf_with_ruby(path, options)
    end

    def save_toc(path)
      File.open(path, 'w'){|f| f.write toc_element.to_yaml}
    end

    def leader_table(data)
      first_page = pages.first
      leader_table = RLeaderTable.new(data:data)
      first_page.add_graphic(leader_table)
    end
  end

end
