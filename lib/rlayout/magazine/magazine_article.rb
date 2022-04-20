# encoding: utf-8

module RLayout
  class MagazineArticle < StyleableDoc
    attr_reader :date
    attr_reader :layout_path, :story_path, :images_dir, :tables_dir
    attr_reader :document, :style, :starting_page_number, :page_count, :page_type # spread, left, right
    attr_reader :doc_info_path, :page_floats, :output_path
    attr_reader :page_count, :column_count, :gutter
    
    def initialize(options={} ,&block)
      @paper_size = options[:paper_size] || 'A4' 
      @page_count = options[:page_count] || 2 
      @gutter = options[:gutter] || 10
      @column_count = options[:column_count] || 3
      @document_path = options[:document_path]
      @style_guide_folder = options[:style_guide_folder] || @document_path
      @doc_info_path = @document_path + "/doc_info.yml"
      load_text_style
      load_layout_rb
      read_page_floats 
      @story_path       = Dir.glob("#{@document_path}/*.{md,markdown}").first
      if !@story_path && @document_path
        puts "No story_path !!!"
        return
      end
      @layout_path    = @document_path + "/layout.rb"
      @output_path  = @document_path + "/article.pdf"
      @pages_path   = @document_path + "/pages"
      @images_dir = @document_path + "/images"
      @tables_dir = @document_path + "/tables"
      @document     = eval(File.open(@layout_path,'r'){|f| f.read})
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@layout_path} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::RDocument)
        puts "Not a @document kind created !!!"
        return
      end
      @document.starting_page_number = @starting_page_number
      @document.fixed_page_document = true
      # place floats to pages
      read_story
      layout_story
      h = {}
      @document.save_pdf(@output_path, save_page_preview: true)
      self
    end

    def page_floats_path
      @document_path + "/page_floats.yml"
    end

    def read_page_floats
      unless File.exist?(page_floats_path)
        puts "Can not find file #{page_floats_path}!!!!"
        return {}
      end
      @page_floats = YAML::load_file(page_floats_path)
    end

    def read_story
      unless File.exist?(@story_path)
        puts "Can not find file #{@story_path}!!!!"
        return {}
      end
      @story = Story.new(@story_path).markdown2para_data
      @heading    = @story[:heading] || {}
      @title      = @heading[:title] || @heading['title'] || @heading['제목'] || "Untitled"
      if @document.pages[0].has_heading?
        @document.pages[0].get_heading.set_heading_content(@heading)
        @document.pages[0].relayout!
      elsif @first_page = @document.pages[0]
        if @first_page.floats.length == 0
          @heading[:parent] = @first_page
          @heading[:x]      = @first_page.left_margin
          @heading[:y]      = @first_page.top_margin
          @heading[:width]  = @first_page.width - @first_page.left_margin - @first_page.right_margin
          @heading[:is_float] = true
          @heading[:heading_height_type] = 'natural'
          RHeading.new(@heading)
        end
      end

      if @page_floats
        @document.pages.each_with_index do |p,i|
          page_floats = @page_floats[i + 1]
          p.add_floats(page_floats)
          p.layout_floats
          p.adjust_overlapping_columns
          p.set_overlapping_grid_rect
          p.update_column_areas
        end
      end

      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para[:layout_expand]  = [:width]
        if para[:markup] == 'img'
          # support ![] syntex
          source = para[:local_image]
          para[:bottom_margin]  = 10
          para[:bottom_inset]   = 10
          para[:image_path] = @images_dir + "/#{source}"
          @paragraphs << Image.new(para)
        elsif para[:markup] == 'image'
          source = para[:local_image]
          para[:bottom_margin]  = 10
          para[:bottom_inset]   = 10
          para[:image_path] = @images_dir + "/#{source}"
          @paragraphs << Image.new(para)
        elsif para[:markup] == 'table'
          para[:layout_expand]  = [:width]
          if para[:csv_path]
            para[:csv_path] = @tables_dir + "/#{para[:csv_path]}"
          end
          @paragraphs << Table.new(para)
        else
          para[:article_type]   = @article_type
          para[:text_fit]       = 0 # FIT_FONT_SIZE
          para[:layout_lines]   = false
          @paragraphs << RParagraph.new(para)
        end
      end
    end

    def default_layout_rb
      h  = {}
      h[:paper_size] = @paper_size
      h[:page_count] = @page_count
      h[:column_count] = @column_count
      h[:gutter] = @gutter
      h[:fixed_page] = true

      s=<<~EOF
      RLayout::RDocument.new(#{h})
    
      EOF

    end

    def layout_story
      current_line =  @document.first_text_line
      while @paragraph = @paragraphs.shift do
        current_line = @paragraph.layout_lines(current_line)
        unless current_line
          @ovewflow = true
          break 
        end
      end
      # if @overflow take care of overflow
      # - show overflow line in red
      # - save overflow text
      # update_header_and_footer
    end

    def next_chapter_starting_page
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
      @document.header_rule = header_rule
      @document.footer_rule = footer_rule
      @document.pages.each {|page| page.update_header_and_footer(options)}
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

    def self.save_rakefile(path)
      rake_text  = <<-EOF.gsub(/^\s*/, "")
      task :default => :pdf

      md_files = FileList["**/*.md", "**/*.markdown"]
      source_files = FileList["**/*.md", "**/*.markdown", "**/layout.rb"]

      task :pdf => source_files.map {|source_file| File.dirname(source_file) + "/output.pdf" }

      source_files.each do |source_file|
        pdf_file = File.dirname(source_file) + "/output.pdf"
        file pdf_file => source_file do
          sh "/Applications/magazine.app/Contents/MacOS/magazine  #{File.dirname(source_file)}"
        end
      end

      task :force do
      	md_files.each do |md_file|
      		sh "/Applications/magazine.app/Contents/MacOS/magazine  #{File.dirname(md_file)}"
      	end
      end

      EOF
      File.open(path, 'w'){|f| f.write rake_text}
    end

    def self.update_if_changed(document_path, options={})
      story_path = document_path + "/story.md"
      pdf_path = document_path + "/story.pdf"
      layout_path = document_path + "/layout.rb"
      if !File.exist?(pdf_path)
        MagazineArticle.new(document_path: document_path)
      elsif File.mtime(story_path) > File.mtime(pdf_path)
        MagazineArticle.new(document_path: document_path)
      elsif File.exist?(layout_path) && File.mtime(layout_path) > File.mtime(pdf_path)
        MagazineArticle.new(document_path: document_path)
      else
        puts "story is upto date..."
      end
    end

  end

end
