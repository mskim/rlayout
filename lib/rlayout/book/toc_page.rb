module RLayout

  # TocPage creae
  class TocPage < Container
    attr_reader :path, :toc_data, :page_number
    attr_reader :heading, :toc_table, :toc_data

    def initialize(options={})
      options[:layout_direction] = 'vertical'
      super
      if options[:parent] || options[:document]
        @parent       = options[:parent] || options[:document]
        @document     = @parent
        @pdf_doc      = @document.pdf_doc
        @column_count   = @document.column_count
        @row_count      = @document.row_count
      else
        @column_count   = 1
        @column_count   = options[:column_count] if options[:column_count]
        @row_count      = 6
        @row_count   = options[:row_count] if options[:row_count]
      end

      if @document
        case @document.paper_size
        when "A4"
          @left_margin    = 100
          @top_margin     = 100
          @right_margin   = 100
          @bottom_margin  = 100
        when "16절"
          @left_margin    = 80
          @top_margin     = 100
          @right_margin   = 80
          @bottom_margin  = 100
        when "A5"
          @left_margin    = 50
          @top_margin     = 80
          @right_margin   = 50
          @bottom_margin  = 80
        else 
          @left_margin    = 50
          @top_margin     = 50
          @right_margin   = 50
          @bottom_margin  = 50
        end

        if !@document.pages.include?(self)
          @document.pages << self
        end
      end

      self
    end

    def is_first_page?
      page_number == 1
    end

    # def add_heading(options={})
    #   options[:parent] = self
    #   options[:x] = @left_margin
    #   options[:y] = @top_margin
    #   options[:width] = @width - @left_margin - @right_margin
    #   @heading  = RHeading.new(options)
    # end

    def add_toc_title(options={})
      options[:parent] = self
      options[:x] = @left_margin
      options[:y] = @top_margin
      options[:text_alignment] = "center"
      options[:width] = @width - @left_margin - @right_margin
      @heading  = Text.new(options)
    end

    def add_toc_table(options={})
      options[:parent] = self
      options[:x] = @left_margin
      options[:y] = @top_margin
      options[:width] = @width - @left_margin - @right_margin
      @toc_table = RLeaderTable.new(options)
    end

    def link_info
      @toc_table.link_info
    end
  end

end