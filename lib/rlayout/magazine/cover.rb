# Cover is used to create Book Cover.
# It has 4 pages, 1,2,3,4
# Each page can have bg_image
# First TocPage strats with RHeading
# page 4 could have 
# handles folded wing, and senaca

module RLayout
  class Cover 
    attr_reader :document_path
    attr_reader :document, :output_path, :column_count
    attr_reader :toc_content
    attr_reader :title, :page_size, :page_count

    def initialize(options={})
      @document_path  = options[:document_path]
      @page_size      = options[:page_size] || 'A5'
      @page_count     = options[:page_count] || 4
      @story_path     = @document_path + "/story.md"
      @output_path    = options[:output_path] || @document_path + "/cover.pdf"
      @layout_rb      = default_document
      @page_pdf       = options[:page_pdf]
      @document       = eval(@layout_rb)
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@document} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::RDocument)
        puts "Not a @document kind created !!!"
        return
      end
      read_story
      layout_toc
      @document.save_pdf(@output_path, page_pdf:@page_pdf) unless options[:no_output]
      self
    end

    def read_story
      @story_path = @document_path + "/story.md"
      unless File.exist?(@story_path)
        puts "/story.md for cover not found!!!"
        @story_md =<<~EOF
        ____
        title : #{title}
        subtitle : #{subtitle}
        author : #{author}
        ___

        EOF

      else
        @story_md = File.open(@story_path, 'r'){|f| f.read}
      end


    end

    def layout_toc

      first_page    = @document.pages.first
      # optins for heding
      h             = {}
      h[:parent]    = first_page
      h[:title]     = "목  차"
      h[:heading_height_type] = "quarter"
      h[:layout_length] = 2
      h[:layout_expand] = [:height]
      first_page.add_heading(h)

      # optins for toc_table
      h                 = {}
      h[:parent]        = first_page
      h[:table_data]    = @toc_content
      h[:layout_length] = 10
      h[:layout_expand] = [:height]
      first_page.add_toc_table(h)
      first_page.relayout!
    end

    def default_document
      layout =<<~EOF
        RLayout::RDocument.new(page_size:"A5", page_count: 1, page_type: "toc_page")
      EOF
    end
  end


end

