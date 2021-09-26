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
        @column_count   = @document.column_count
        @row_count      = @document.row_count
      else
        @column_count   = 1
        @column_count   = options[:column_count] if options[:column_count]
        @row_count      = 6
        @row_count   = options[:row_count] if options[:row_count]
      end

      if @document
        @left_margin    = @document.left_margin
        @top_margin     = @document.top_margin
        @right_margin   = @document.right_margin
        @bottom_margin  = @document.bottom_margin
        if !@document.pages.include?(self)
          @document.pages << self
        end
      end

      self
    end

    def is_first_page?
      page_number == 1
    end

    def add_heading(options={})
      options[:x] = @left_margin
      options[:y] = @top_margin
      options[:width] = @width - @left_margin - @right_margin
      @heading  = RHeading.new(options)
    end

    def add_toc_table(options={})
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