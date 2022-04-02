module RLayout
  class RDocumentV < RDocument
    attr_reader :orientation

    def initialize(options={}, &block)
      super

    end

    def set_margins

    end

    def set_column_size
      @column_width = (@width - @left_margin - @right_margin ))
      @column_height = (@height - @top_margin - @bottom_margin - @gutter*(@column_count - 1))/@column_countV.new(h)
    end

    def set_body_line_height
      
    end

    # create new page and return first line of new page
    def add_new_page(options={})
      if @page_type == "toc_page"
        h                 = {}
        h[:parent]        = self
        h[:width]         = @width
        h[:height]        = @height
        h[:page_number]   = @pages.length + 1
        h[:toc_data]      = @toc_data
        new_page          = TocPage.new(h)
      elsif @page_type == "inside_cover"
        h                 = {}
        h[:parent]        = self
        h[:width]         = @width
        h[:height]        = @height
        h[:page_number]   = @pages.length + 1
        # h[:toc_data]      = @toc_data
        new_page          = InsideCoverPage.new(h)
        # inside_cover
      elsif @page_type == "column_text"
        # short column text
        # isbn, dedication, thanks
        h                 = {}
        h[:parent]        = self
        h[:width]         = @width
        h[:height]        = @height
        h[:page_number]   = @pages.length + 1
        # h[:toc_data]      = @toc_data
        new_page          = ColumnTextPage.new(h)
      else
        h                 = {}
        h[:parent]        = self
        h[:width]         = @width
        h[:height]        = @height
        h[:page_number]   = @pages.length + @starting_page_number
        h[:float_layout]  += page_float_layout[options[:page_index]] if @page_float_layout
        previous_line = @pages.last.last_line if @pages.length > 0 && @pages.last.last_line
        new_page = RPageV.new(h)
        new_page_first_line = new_page.first_text_line
        previous_line.next_line = new_page_first_line if previous_line
        new_page_first_line
      end
    end


  end
end