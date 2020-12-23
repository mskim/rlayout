# encoding: utf-8

# Article 
# Article layout is different from NewsArticle or Chapter.
# RDocument doest not not have page floats info
# RDocument should not create page at eval, instead each page float info is  given to an article.
# Article create each page with float_info.
# body paragraph are layed out after all the page floats are placed. 

module RLayout

  class Article
    attr_accessor :template_path, :story_path
    attr_accessor :document, :output_path, :column_count
    attr_accessor :doc_info, :toc_content
    attr_reader :book_title, :title, :starting_page
    attr_reader :page_count, :layout_rb
    attr_reader :story, :story_body, :floats, :page_layout, :jpg, :time_stamp
    attr_reader :paragraphs
    def initialize(options={})
      @page_count     = options[:page_count]
      @output_path    = options[:output_path]
      @story_body     = options[:story_body]
      @document_script= options[:document_script]
      @page_layout    = options[:page_layout]
      @jpg            = options[:jpg]
      @time_stamp     = options[:time_stamp]
      @document = eval(@document_script)
      if @document.is_a?(SyntaxError)
        puts "SyntaxError !!!!"
        return
      end
      unless @document.kind_of?(RLayout::RDocument)
        puts "Not a RDocument @document kind created !!!"
        return
      end
      @starting_page = options.fetch(:starting_page,1)
      @document.starting_page = @starting_page
      @page_layout.each_with_index do |page_info, i|
        page_info[:page_number] = @starting_page + 1
        new_page = @document.add_new_page
        new_page.add_floats(page_info)
      end
      if @story_body
        @paragraphs =[]
        starting_heading_level = options[:starting_heading_level] || 1
        para_data  = Story.body2para_data(@story_body, starting_heading_level)
        para_data.each do |para|
          @paragraphs << RParagraph.new(para)
        end
      else
        read_story
      end
      # TODO
      # layout_story
      output_options = {jpg: @jpg}
      @document.save_pdf_in_ruby(@output_path,output_options) unless options[:no_output]
      # @doc_info[:starting_page] = @starting_page
      # @doc_info[:page_count] = @document.pages.length
      # save_toc
      self
    end

    def read_story

      ext = File.extname(@story_path)
      if ext == ".md" || ext == ".markdown" || ext == ".story"
        @story  = Story.new(@story_path).markdown2para_data
      end
      @heading      = @story[:heading] || {}
      @book_title   = @heading[:book_title] || @heading['book_title'] || "Untitled"
      @title        = @heading[:title] || @heading['title'] || "Untitled"
      @toc_content  = "## #{@title}\t0\n"
      @paragraphs   = []
      @story[:paragraphs].each do |para|
        next if para.nil?
        para[:layout_expand] = [:width]
        if para[:markup] == 'img' && para[:para_string]
          para.merge! eval(para.delete(:para_string))
          @paragraphs << Image.new(para_options)
        elsif para[:markup] == 'table'
          @paragraphs << Table.new(para)
        elsif para[:markup] == 'photo_page'
          @paragraphs << PhotoPage.new(para)
        elsif para[:markup] == 'float_group'
          @paragraphs << FloatGroup.new(para)
        elsif para[:markup] == 'pdf_insert'
          @paragraphs << PdfInsert.new(para)
        elsif para[:markup] == 'ordered_list'
          @paragraphs << OrderedList.new(para)
        elsif para[:markup] == 'unordered_list'
          @paragraphs << UnorderedList.new(para)
        else
          @paragraphs << Paragraph.new(para)
        end
      end
    end

    def layout_story
      @page_index               = 0
      @first_page               = @document.pages[0]
      @heading[:layout_expand]  = [:width, :height]
      heading_object            = Heading.new(@heading)
      @first_page.graphics.unshift(heading_object)
      heading_object.parent = @first_page
      unless @first_page.main_box
        @first_page.create_main_text
      end
      @first_page.relayout!
      @first_page.main_box.adjust_column_lines
      @first_page.main_box.set_overlapping_grid_rect
      first_item = @paragraphs.first
      #TODO
      if first_item.is_a?(FloatGroup) # || first_item.is_a?(PdfInsert)
        first_item = @paragraphs.shift
        first_item.layout_page(document: @document, page_index: @page_index)
      end

      @first_page.main_box.layout_items(@paragraphs)
      @page_index = 1
      while @paragraphs.length > 0
        if @page_index >= @document.pages.length
          options               = {}
          options[:parent]      = @document
          options[:footer]      = true
          options[:header]      = true
          options[:text_box]    = true
          options[:column_count]= @document.column_count
          p = Page.new(options)
          p.relayout!
          p.main_box.create_column_grid_rects
        end

        if @document.pages[@page_index].main_box.nil?
          @document.pages[@page_index].main_text
          @document.pages[@page_index].relayout!
        end
        first_item = @paragraphs.first
        if first_item.is_a?(FloatGroup) # || first_item.is_a?(PdfInsert)
          first_item = @paragraphs.shift
          first_item.layout_page(document: @document, page_index: @page_index)
        end
        @document.pages[@page_index].main_box.layout_items(@paragraphs)
        @page_index += 1
      end

      update_header_and_footer
    end

    def next_chapter_starting_page
      @starting_page = 1 if @starting_page.nil?
      @page_view_count = 0   if @page_view_count.nil?
      @starting_page + @page_view_count
    end

    def save_toc
      toc_path = @project_path + "/doc_info.yml"
      @doc_info[:toc] = @toc_content
      File.open(toc_path, 'w') { |f| f.write @doc_info.to_yaml}
    end

    def update_header_and_footer
      header = {}
      header[:first_page_text]  = "| #{@book_title} |" if @book_title
      header[:left_page_text]   = "| #{@book_title} |" if @book_title
      header[:right_page_text]  = @title if @title
      footer = {}
      footer[:first_page_text]  = @book_title if @book_title
      footer[:left_page_text]   = @book_title if @book_title
      footer[:right_page_text]  = @title if @title
      options = {
        header: header,
        footer: footer
      }
      @document.header_rule = header_rule
      @document.footer_rule = footer_rule
      @document.pages.each { |page| page.update_header_and_footer(options)}
    end

    def header_rule
      {
        first_page_only: true,
        left_page: false,
        right_page: false
      }
    end

    def footer_rule
      h = {}
      h[:first_page]      = true
      h[:left_page]       = true
      h[:right_page]      = true
      h
    end
    # generate layout.rb file with script in each page
    # for manual image adjusting
    def generate_layout
      @page_content = ''
      layout_text = <<-EOF.gsub(/^\s*/, "")
      RLayout::Document.new do
        #{@page_content}
      EOF
      page_text = <<-EOF.gsub(/^\s*/, "")
        #page: #{@page_number}
        page do
          main_text do
            #{@image_layout}
          end
        end
      EOF
      @document.pages.each_with_index do |page, i|
        @page_number = i + 1
        @image_layout = ''
        page.floats.each do |float|
          @image_layout += float.to_script
        end
        @page_content += page_text
      end
      layout_file = layout_text
      File.open(layout_path, 'w') { |f| f.write layout_file }
    end
  end
end
