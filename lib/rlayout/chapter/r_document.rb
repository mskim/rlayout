# encoding: utf-8


# story is parsed as series of paragraph
# paragraph
# document has story
# page has column_box
# column_box has lines
# r_text_text_box has story
# single_column_text_box has story
# heading has single_column_text_box
#     - TitleText < TextBox
#     - SubtitleText < TextBox
#     - QuoteText < TextBox
#     -
#
# StoryContainer
#   story
#   paragraph
# Document
#   pages
# TextBox < Container
#   column_box
#   column_count


module RLayout

  class RDocument
    attr_accessor :title, :path, :page_size, :portrait, :width, :height, :starts_left, :double_side
    attr_accessor :left_margin, :top_margin, :right_margin, :bottom_margin
    attr_accessor :pages, :document_view, :starting_page
    attr_accessor :page_view_count, :toc_elements
    attr_accessor :header_rule, :footer_rule, :gim
    attr_accessor :left_margin, :top_margin, :right_margin, :bottom_margin, :gutter
    attr_accessor :pdf_path, :jpg, :preview, :column_count, :column_width, :layout_style
    attr_accessor :heading_type, :body_line_count, :body_line_height
    attr_reader :project_path, :max_page_number, :page_count, :starting_page
    
    def initialize(options={}, &block)

      @starting_page    = options[:starting_page]   || 1
      @width            = options[:width]
      @height            = options[:height]
      @max_page_number  = options[:max_page_number] || 999
      @body_line_count  = options[:body_line_count] || 23
      @left_margin      = options[:left_margin]     || 50
      @top_margin       = options[:top_margin]      || 50
      @right_margin     = options[:right_margin]    || 50
      @bottom_margin    = options[:bottom_margin]   || 50
      @column_count     = options[:c]               || 1
      @gutter           = options[:gutter]          || 10
      unless @body_line_height
        @body_line_height   = (@height - @top_margin - @bottom_margin)/@body_line_count
      end
      @column_width = (@width - @left_margin - @right_margin - @gutter*(@column_count - 1))/@column_count
      @pages            = []
      @page_count       = options[:page_count]
      @page_count.times do 
        add_new_page
      end
      if block
        instance_eval(&block)
      end
      self
    end

    def first_line
      @pages.first.graphics.first
    end

    def first_text_line
      @pages.first.first_text_line
    end

    def layout_rect
      [@left_margin, @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin]
    end

    # create new page and return first line of of main_box
    def add_new_page(options={})
      h                 = {}
      h[:parent]        = self
      h[:width]         = @width
      h[:height]        = @height
      h[:page_number]   = @pages.length
      h[:page_number]   += @starting_page
      new_page = RPage.new(h)
      # new_page.first_line
      new_page.first_text_line
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

    def save_svg(path, options={})
      puts "++++++++++++ save_svg"
      "path:#{path}"
      s= path
      "some string"
    end

    def save_pdf(path, options={})
      save_pdf_with_ruby(path, options={})
    end

    def save_toc(path)
      File.open(path, 'w'){|f| f.write toc_element.to_yaml}
    end

    def save_page_by_page
      save_page_folders
      save_page_markdown
    end

    def save_page_folders
      puts __method__
    end

    def save_page_markdown
      puts __method__
    end
  end

end
