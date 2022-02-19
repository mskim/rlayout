# encoding: utf-8

# Chapter
# Chapter converts given Story into a document.
# - story.md is parsed to heading and body. 
# - Heading is placed at the top in yaml format.
# - Body markups are converted to series of paragraphs,

## How to place images in long document?
# There are two ways of placing images in the long document.
# 1. inline image markup
# 2. pre-planed separate yaml file containeing image info for page.

# 3. inserting pre-made PDF photo pages with markup at insertion point

### First method is to inline image markup in the text.
# - Image tag will trigger new page except the first page
# - It is recommanded to start with image markup at the beginning of page content
# - and put rest of text after the image markup. 
# - So, the images will be placed into page as floats first, then text will floow arount it.
# - 그림_1(크기:전면)
# - 그림_2(위치:상단, 크기:반)
# - 그림_1(크기:전면)
# - 그림_2(위치:상단, 크기:반)
# - 그림_3(위치:하단, 크기:반), bottom positin of size 1
# - 그림_4 기본은 (위치:상단, 크기:반)
# - 그림_5,

# - We can also puts multiple images in the same page, for this we need to group them as "그림_조합_1"
# - this represents collection of images that will be place in the same page.
# - multiple_image can be placed in a single page by
# - putting using 그림_조합_1 same image info in the same text block
# - should create subfolder 그림_조합_1 folder within images folder
# - staeting with 그림_조합
# - 그림_조합_1
# - 그림_1(3, 1x1)
# - 그림_2(3, 1x1)
# - 그림_3(3, 1x1)
# - it will push down image if multiple images have same positioon
# - this has effoct of vertical alignment

### And second way is to use float_group.
# - Float_group is a floating images layout on top of a page,
# - where text flows aroud those images.
# - Float_group containes position information,
# - such as grid_frame, size, position attributes.
# - New page is triggered with Float_group. pre-desinged layout pattern can also be used.

### And the third method is to use photo_page,
# - photo_page can containe more then one page.
# - New page section is triggered for photo_page.
# - photo_page is pure photo only page, no text flows in the page,
# - no header, no footer, no page number.
# - pre-desinged layout pattern can be pulled from pattern library
# - or positions can be set manually.

### For short documents, such as magazine article,
# - desinger can place image in rlayout file.
# - And image info in specified in meta-data header
# - or design template by designer.


### How to place image caption?
# - File that has same name with extension of .caption?
# - Or have the caption text as file name.jpg

### How to add Image bleeding support


# when we encounter page triggering node, add new page
#    section_1, photo_page, image_group

# LongDocument
# LongDocument is made to handle collection of document parts, for long document.
# Typical LongDocument parts are, title_page, section, photo_page, image_group_page.
# and pdf_insert.

# pdf_insert is pre-made pdf pages that are inserted in the middle of chapter.


# Story file
# story files are markuped text, with markdown or asciidoctor syntax.
# I am adding some of my own markups to asciidoctor adoc with extension.
# I should transform them into Asciidoctor, LqTex, or markdown format.
# And it should be simple.
# First part is meta-data
# And followed by block data.
# Block data is separated by new empty line.
#

# meta-data
# ---
# yaml format key value pair
# title:
# subtitle:
# quote:
# author:
# book_title:
# chapter_title:
# strting_page:
# page_count:
# ---

# New Page Triggering mark
# [photo_page]
# [image_group]
# [pdf_insert]

# title page marks (in meta-data)
# title:
# subtitle:
# quote:
# leading:
# author:
# description:

# paragraph mark
# [p]
# [sub_p]
# [subsub_p]
# [dropcap]

# block mark
# [warning]
# [notice]
# [source, ruby]
# [image]
# [table]
# [math]

# block attributes
# :style: my_style1
# :shape: round_rect
# example
# [math]
# :align: true
# :number: true

# inline mark
# _italic_
# *bold*
# underline
# $$math$$
# ^super^
# sub
# {{box}}
# {{base}{ruby}}
# {{base}{reverse_ruby}}

# class String
#   def blank?
#     !include?(/[^[:space:]]/)
#   end
# end

# heading_height_type
#   fixed height: use HeightContent

#   natural, quarter, half, full_page

#   natural: growing height: use Heading

# chapter folder
# config.yml
# images/
# story.md
# output format
# output.pdf
# page_001
# page_002
# page_003
# Glyph for "ö" missing for KoPubBatangPM
# Shinmoon is OK

# adding pictures in chapter
# 1. first way is to insert text markup in md file
# a single line text starting with 그림_1/picture_1 followed by number
# grid 6x12 grid
# 그림_1(1_6x6)
# 그림_2(1_6x6)
# put 그림_3(1_6x6)
# default_image_location: 1
# default_image_size: 6x6
# 2. second way is to create page_image_layut.yml file specifiying page_number and image_name, locatin, size
# 
# page_by_page is used for page proof reading
# if page_by_page is true,
# folders are created for each page, with jpg image and, markdown text for that page
# this allow the proofer to work on that specific page rather than dealing with entire chapter text.
# page_pdf options indicates to split docemnt into pages
# page_folder are 4 digit numbered 0001, 0002, 0003

# page_pdf
# if page_pdf options is true, create a folder for each page.
# 0001, 0002 so and put page.pdf and page.jpg
# This is used for  ebook generation

# toc
# if toc options is true, save toc.yml for the chapter
module RLayout
  class RChapter
    attr_reader :document_path, :story_path
    attr_reader :document, :output_path, :column_count
    attr_reader :doc_info, :toc_content
    attr_reader :book_title, :title, :starting_page_number, :heading_height_type, :heading
    attr_reader :body_line_count, :body_line_height
    attr_reader :max_page_number, :page_floats
    attr_reader :has_footer, :has_header
    attr_reader :belongs_to_part, :paper_size
    attr_reader :page_by_page, :story_md, :story_by_page, :toc
    attr_reader :grid, :default_image_location, :default_image_size
    attr_reader :local_image_folder
    attr_reader :starting_page_side # :left, :right, :either
                                    # Some document should start on specific side, isbn left(even), inside_cover right(odd),
                                    # blank page is inserted in front of the document to make it work.

    def initialize(options={} ,&block)
      @document_path  = options[:document_path]
      @custom_style = options[:custom_style]
      @starting_page_side = options[:starting_page_side] || :either_side
      if options[:book_info]
        @book_info      = options[:book_info]
        @paper_size     = @book_info[:paper_size] || "A5"
        @book_title     = @book_info[:tittle] || "untitled"
      else
        @paper_size     = options[:paper_size] || "A5"
        @book_title     = options[:book_tittle] || "untitled"
      end
      @local_image_folder = @document_path + "/images"
      @story_path     = @document_path + "/story.md"
      @output_path    = options[:output_path] || @document_path + "/chapter.pdf"
      @story_md       = options[:story_md]
      @has_footer    =  options[:has_footer] || true
      @has_header    =  options[:has_header] || false
      @belongs_to_part = options[:belongs_to_part]
      @grid = options[:grid] || [6,12]
      @default_image_location = options[:default_image_location] || 1
      @default_image_size = options[:default_image_size] || [6,6]
      @starting_page_number  = options[:starting_page_number] || 1
      @page_by_page   = options[:page_by_page]
      @page_pdf       = options[:page_pdf]
      @svg            = options[:svg]
      @story_by_page  = options[:story_by_page]
      @toc            = options[:toc]
      @toc_level      = options[:toc_level] || 'title'
      @layout_rb      = options[:layout_rb]
      unless @layout_rb
        layout_path = @document_path + "/layout.rb"
        if File.exist?(layout_path)
          @layout_rb = File.open(layout_path, 'r'){|f| f.read}
        else
          @layout_rb = default_document_layout
        end
      end
      @document       = eval(@layout_rb)
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@document} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::RDocument)
        puts "Not a @document kind created !!!"
        return
      end
      @toc_content                = []
      @document.document_path = @document_path
      @document.starting_page_number = @starting_page_number
      load_text_style
      read_story
      place_page_floats(options)
      layout_story
      place_header_and_footer
      @document.save_pdf(@output_path, page_pdf:@page_pdf) unless options[:no_output]
      @document.save_svg(@document_path) if @svg
      save_story_by_page if @story_by_page
      save_toc if @toc
      # save_line_log # used for debug
      self
    end

    def default_document_layout
      @top_margin = 50
      @left_margin = 110
      @right_margin = 110
      @bottom_margin = 110
      case @paper_size
      when "A4"
        @body_line_count  = 40 
      when "A5"
        @body_line_count  = 25
        @top_margin = 50
        @left_margin = 80
        @right_margin = 80
        @bottom_margin = 110
      when "16절", "197x272", "197X272"
        @body_line_count  = 25
      else
        @body_line_count  = 25
      end
      doc_options= {}
      doc_options[:paper_size] = @paper_size
      doc_options[:left_margin] = @left_margin
      doc_options[:top_margin] = @top_margin
      doc_options[:right_margin] = @right_margin
      doc_options[:bottom_margin] = @bottom_margin
      doc_options[:body_line_count] = @body_line_count
      doc_options[:book_title] = @book_title || "untitled"
      doc_options[:chapter_title] = @title || "untitled"
      layout =<<~EOF
        RLayout::RDocument.new(#{doc_options})
      EOF
    end

    def save_line_log
      log = @document.log
      log_path = @document_path + "/log.md"
      File.open(log_path, 'w'){|f| f.write log}
    end

    def save_para_string
      story_paras =  "" 
      @paragraphs.each do |p|
        story_paras += p.para_string
        story_paras += "\n\n"
      end
      story_paras_path = @document_path + "/story_para.md"
      File.open(story_paras_path, 'w'){|f| f.write story_paras}
    end

    def has_page_floats_info?
      @page_floats && @page_floats != {}
    end

    def page_count
      @document.pages.length
    end

    def story_by_page_path
      @document_path + "/story_by_page.yml"
    end

    def save_story_by_page
      File.open(story_by_page_path, 'w'){|f| f.write @story_by_page_hash.to_yaml}
    end

    def read_story
      if @story_md 
        @story  = Story.new(nil).markdown2para_data(source:@story_md)
      else
        @story  = Story.new(@story_path).markdown2para_data
      end
      @heading  = @story[:heading] || {}
      @title    = @heading[:title] || @heading['title'] || @heading['제목'] || "Untitled"
      @first_page = @document.pages[0]
      if @first_page.has_heading?
        @document.pages[0].get_heading.set_heading_content(@heading)
        @document.pages[0].relayout!
      else
        @heading[:parent] = @first_page
        @heading[:x]      = @first_page.left_margin # left_margin + binding_margin
        @heading[:y]      = @first_page.top_margin
        @heading[:width]  = @first_page.content_width # - @first_page.left_margin - @first_page.right_margin
        @heading[:is_float] = true
        @heading[:heading_height_type] = 'quarter'
        RHeading.new(@heading)
        @first_page.layout_floats
        @first_page.adjust_overlapping_columns
      end
      @paragraphs =[]
      @image_count = 0
      @left_margin = @document.pages[0].left_margin
      @top_margin = @document.pages[0].top_margin
      @width = @document.pages[0].width
      @story[:paragraphs].each do |para, i|
        if  para[:markup] == "image"
          @image_count += 1
          float_info = {}
          # float_info[:position] = 1
          float_info[:x] = @left_margin
          float_info[:y] = @top_margin
          float_info[:width] = @width - @left_margin*2
          float_info[:height] = (@height - @top_margin*2)/2 - 20
          float_info[:image_path] = @local_image_folder + "/#{@image_count}.jpg"
          float_info[:kind] = "image"
          # TODO: fix this ????
          float_info[:image_path] =  Dir.glob("#{@local_image_folder}/#{@image_count}.{jpg,png,pdf}").first
          if float_info[:image_path] && File.exist?(float_info[:image_path])
            extension = File.extname(float_info[:image_path])
            image_info_path = float_info[:image_path].sub("#{extension}", ".yml")
            if File.exist?(image_info_path)
              image_info = YAML::load_file(image_info_path)
              float_info.merge!(image_info)
            end
          end
          para_options = {}
          para_options[:markup] = "image"
          para_options[:float_info] = float_info
          @paragraphs << RParagraph.new(para_options)
        elsif  para[:markup] == "table"

        else
          para_options = {}
          para_options[:markup]         = para[:markup]
          para_options[:layout_expand]  = [:width]
          para_options[:para_string]    = para[:para_string]
          @paragraphs << RParagraph.new(para_options)
        end
      end
    end
    
    def place_page_floats(options)
      if options[:page_floats]
        @page_floats      = options.fetch(:page_floats, [])
      else
        read_page_floats 
      end

      if has_page_floats_info?
        @has_page_floats_info = true
        last_floats_page_number = @page_floats.keys.sort.last
        need_page_count = last_floats_page_number - @document.pages.length
        if need_page_count > 0
          need_page_count.times do 
            @document.add_new_page
          end
        end
        @document.pages.each_with_index do |p,i|
          page_floats_for_page = @page_floats[i + 1]
          if page_floats_for_page
            p.add_floats(page_floats_for_page) 
          end
        end
      end
    end

    def page_floats_path
      @document_path + "/page_floats.yml"
    end

    def read_page_floats
      unless File.exists?(page_floats_path)
        @page_floats = {}
      else
        @page_floats = YAML::load_file(page_floats_path)
      end
    end

    def document_text_style_path
      @document_path + "/document_text_style.yml"
    end

    def layout_story
      @document.pages.each do |page|
        page.layout_floats
        page.adjust_overlapping_columns
        page.set_overlapping_grid_rect
        page.update_column_areas
      end
      @first_text_page  = @document.pages.select{|p| p.first_text_line}.first
      unless @first_text_page
        @current_line = @document.add_new_page
      else
        @current_line = @first_text_page.first_text_line
      end
      page_key                    = @current_line.page_number
      @story_by_page_hash         = {} # this is used to capter story_by_page info
      current_page_paragraph_list = []
      while @paragraph = @paragraphs.shift
        # TODO: capturing paragraph info to save @story_by_page
        @current_line                   = @paragraph.layout_lines(@current_line)
        current_page_paragraph_list     << @paragraph.para_info
        if @toc_level == 'title'
        elsif @paragraph.markup != 'p'
          toc_item = {}
          toc_item[:page] = page_key
          toc_item[:markup] = @paragraph.markup
          toc_item[:para_string] = @paragraph.para_string
          @toc_content << toc_item
        end
        unless @current_line
          @current_line                 = @document.add_new_page
          @story_by_page_hash[page_key] = current_page_paragraph_list
          current_page_paragraph_list   = []
          page_key                      = @current_line.page_number
        end
        if @current_line.page_number != page_key
          @story_by_page_hash[page_key] = current_page_paragraph_list
          current_page_paragraph_list   = []
          # current_page_hash             = {}
          page_key                      = @current_line.page_number
          # current_page_hash[page_key]   = []
        end
      end
    end

    def place_header_and_footer
      chapter_info ={}
      chapter_info[:book_title] = @book_info[:title] if @book_info
      chapter_info[:chapter_title] = @title if @title
      if @has_header
        @document.pages.each_with_index do |p,i|
          # use comstom layout if given in book_info
          chapter_info[:footer_layout]  = chapter_info[:footer_layout] if @book_info
          p.create_header(chapter_info) 
        end
      end
      if @has_footer
        @document.pages.each_with_index do |p,i|
          chapter_info[:footer_layout]  = chapter_info[:footer_layout] if @book_info
          p.create_footer(chapter_info) 
        end
      end
    end

    def next_chapter_starting_page
      @starting_page_number = 1 if @starting_page_number.nil?
      @page_view_count = 0   if @page_view_count.nil?
      @starting_page_number + @page_view_count
    end

    def doc_info_path
      @document_path + "/doc_info.yml"
    end

    def save_doc_info
      # doc_info_path   = @document_path + "/doc_info.yml"
      @doc_info[:toc] = @toc_content
      File.open(toc_path, 'w') { |f| f.write @doc_info.to_yaml}
    end

    def save_toc
      @document_path  = File.dirname(@output_path)
      toc_path        = @document_path + "/toc.yml"
      if @toc_level == 'title'
        toc_item = {}
        toc_item[:page] = @starting_page_number
        toc_item[:markup] = 'h1'
        toc_item[:markup] = 'h2' if @belongs_to_part
        toc_item[:para_string] = @title
        @toc_content << toc_item
      end
      File.open(toc_path, 'w') { |f| f.write @toc_content.to_yaml}
    end

  end
end
