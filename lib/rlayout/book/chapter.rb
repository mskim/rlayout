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

# - We can also put multiple images in the same page, for this we need to group them as "그림_조합_1"
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
#   natural, quarter, half, full_pag
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

# starting_page_side
# :left, :right, :either
# Some document should start on specific side, isbn left(even), inside_cover right(odd),
# blank page is inserted in front of the document to make it work.

# Styleable module
# Styleable module allows customizarion of documents
# There are tree part to customizarion
# text_style, header_footer, and layout
# styles can be modified by changing saved default values,
# default style are save at /style_guide/class_name folder
# and modified version gets applied.

module RLayout
  class Chapter
    attr_reader :document_path
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    attr_reader :page_pdf
    attr_reader :starting_page_number
    attr_reader :output_path
    attr_reader :header_footer_info
    attr_reader :body_line_count
    attr_reader :book_title, :chapter_title
    attr_reader :story_path
    attr_reader :column_count
    attr_reader :doc_info, :toc_content
    attr_reader :title, :toc_title, :heading_height_type, :heading
    attr_reader :body_line_height
    attr_reader :max_page_number, :page_floats
    attr_reader :has_footer, :has_header
    attr_reader :belongs_to_part, :paper_size
    attr_reader :page_by_page, :story_md, :story_by_page, :toc
    attr_reader :grid, :default_image_location, :default_image_size
    attr_reader :local_image_fold
    attr_reader :footnote_description_items
    attr_reader :starting_page_side, :jpg
    attr_reader :book_info

    include Styleable

    def initialize(options={} ,&block)
      @doc_type = options[:doc_type] || 'chapter'
      @book_info = options.dup
      @jpg = options[:jpg] || false
      @style_guide_folder = options[:style_guide_folder] || @document_path
      @document_path = options[:document_path]
      @starting_page_number  = options[:starting_page_number] || 1
      @output_path = options[:output_path] || @document_path + "/chapter.pdf"
      @width = options[:width]
      @height = options[:height]
      @left_margin = options[:left_margin]
      @top_margin = options[:top_margin]
      @right_margin = options[:right_margin]
      @bottom_margin = options[:bottom_margin]
      @page_pdf =  options[:page_pdf] || false
      @body_line_count = options[:body_line_count]
      @book_title = options[:book_title]
      load_doc_style
      @footnote_description_items = []
      @starting_page_side = options[:starting_page_side] || :either_sid
      @local_image_folder = @document_path + "/images"
      @story_path     = @document_path + "/story.md"
      @output_path    = options[:output_path] || @document_path + "/chapter.pdf"
      @story_md       = options[:story_md]
      @belongs_to_part = options[:belongs_to_part]
      @grid = options[:grid] || [6,12]
      @default_image_location = options[:default_image_location] || 1
      @default_image_size = options[:default_image_size] || [6,6]
      @page_by_page   = options[:page_by_page]
      @svg            = options[:svg]
      @story_by_page  = options[:story_by_page]
      @toc            = options[:toc]
      @toc_level      = options[:toc_level] || 'title'
      @toc_content                = []
      @document.document_path = @document_path
      @document.set_starting_page_number(@starting_page_number)
      place_page_floats(options)

      if @doc_type == 'poem' || @doc_type == 'poetry_book'
        read_poem
        layout_poem
      else
        read_story
        layout_story
      end
      place_header_and_footer
      @document.save_pdf(@output_path, page_pdf:@page_pdf, jpg: @jpg) unless options[:no_output]
      # @document.save_svg(@document_path) if @svg
      save_story_by_page if @story_by_page
      save_toc if @toc
      self
    end

    # allow values to be customizable
    def load_defaults
      if File.exist?(style_guide_defaults_path)
        default_options = YAML::load_file(style_guide_defaults_path)
      else
        default_options = YAML::load(defaults)
        File.open(style_guide_defaults_path, 'w'){|f| f.write defaults}
      end
      # TODO ??? how to set values to instance varible with same name
      @heading_height_type  = default_options['heading_height_type']
      @heading_height_in_line_count  = default_options['heading_height_in_line_count']
      @footnote_description_text_prefix = default_options['footnote_description_text_prefix']
    end

    def  defaults
      <<~EOF
      ---
      heading_height_type: quarter
      heading_height_in_line_count: 9

      EOF
    end


    def default_header_footer_yml
      <<~EOF
      ---
      has_hearder: false
      has_footer: true
      left_header_erb: |
        RLayout::Container.new(parent:self, x: <%= @left_margin %>, y:20, width: <%= footer_width  %>, height: 12, fill_color: 'clear') do
          text("<%= @page_number %>", style_name: 'header, x: <%= @left_margin %>, width: <%= footer_width  %>, text_alignment: 'left')
        end
      right_header_erb: |
        RLayout::Container.new(parent:self, x: <%= @left_margin %>, y:20, width: <%= footer_width  %>, height: 12, fill_color: 'clear') do
          text("<%= @title %>  <%= @page_number %>", style_name: 'header, from_right:0, y: 0, text_alignment: 'right')
        end
      left_footer_erb: |
        RLayout::Container.new(parent:self, x:<%= @left_margin %>, y:<%= @height - 50 %>, width: <%= footer_width  %>, height: 12, fill_color: 'clear') do
          text("<%= @page_number %>  <%= @book_title %>", style_name: 'footer, x:0, y:0, width: <%= footer_width  %>, text_alignment: 'left')
        end
      right_footer_erb: |
        RLayout::Container.new(parent:self, x:<%= @left_margin %>, y:<%= @height - 50 %>, width: <%= footer_width  %>, height: 12, fill_color: 'clear') do
          text("<%= @title %>  <%= @page_number %>", style_name: 'footer, x:0, y: 0, width:<%= footer_width  %>, text_alignment: 'right')
        end

      ---

      EOF
    end

    def default_layout_rb
      doc_options= {}
      doc_options[:width] = @width
      doc_options[:height] = @height
      doc_options[:left_margin] = @left_margin
      doc_options[:top_margin] = @top_margin
      doc_options[:right_margin] = @right_margin
      doc_options[:bottom_margin] = @bottom_margin
      doc_options[:body_line_count] = @body_line_count
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
        @heading[:heading_height_type] = 'quarter' # 9 as line_count
        @heading[:heading_height_in_line_count] = @heading_height_in_line_count # 9 as body_line_count
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
        elsif  para[:markup] == "footnote_item"
          @footnote_description_items << para
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
      unless File.exist?(page_floats_path)
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
      @story_by_page_hash         = {} # this is used to capture story_by_page info
      current_page_paragraph_list = []
      while @paragraph = @paragraphs.shift
        if @paragraph.has_footnote_marker
          current_column = @current_line.column
          currunt_para_footnote_markers = @paragraph.footnote_marker_numbers
          footnote_description_items_to_add_for_column = []
          currunt_para_footnote_markers.each do |marker_number|
            footnote_description_items_to_add_for_column += @footnote_description_items.select do |item|
              item[:footnote_item_number] == marker_number
            end
          end
          footnote_description_items_to_add_for_column.flatten
          current_column.add_footnote_description_items(footnote_description_items_to_add_for_column)
        end
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

    def read_poem
      @first_page = @document.pages[0]
      @story  = Story.new(@story_path).story2line_text
      @heading  = @story[:heading] || {}
      @title    = @heading[:title] || @heading['title'] || @heading['제목'] || "Untitled"
      @text_lines = []
      @story[:line_text].each do |line_text|
        @text_lines << line_text
      end
    end
  
    def layout_poem
      @toc_content = []
      line_options = {}
      line_options[:x]  = 50
      line_options[:y]  = 30
      line_options[:width]  = @first_page.width
      line_options[:height]  = 50
      line_options[:text_string]    = @title
      line_options[:parent] = @first_page
      line_options[:font_size] = 16
      Text.new(line_options)
      @starting_y = 100
      line_height = 20
      @text_lines.each do |line_text|
        line_options = {}
        line_options[:x]  = 50
        line_options[:y]  = @starting_y
        line_options[:width]  = @first_page.width
        line_options[:height]  = line_height
        line_options[:text_string]    = line_text
        line_options[:parent] = @first_page
        line_options[:font_size] = 12
        Text.new(line_options)
        @starting_y += line_height
      end
    end

    # @header_footer_info hash is read by StyleableDoc
    # @header_footer_info keys include has_header, has_footer, 
    # these values can be customized to true or false for each class
    # /style_guide/chapter_header_footer.yml

    def place_header_and_footer
      # @header_footer_info = YAML::load_file(style_guide_header_footer_path)
      @has_header = @header_footer_info['has_header'] ||  @header_footer_info[:has_header]
      @has_footer = @header_footer_info['has_footer'] || @header_footer_info[:has_footer]
      chapter_info ={}
      chapter_info[:book_title] = @book_info[:book_title] ||  @book_info[:title] if @book_info
      chapter_info[:chapter_title] = @title || " " 
      if @has_header ||  @has_footer
        @document.set_header_footer_info @header_footer_info
      end

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
      @doc_info = {}
      @doc_info[:paper_size] = @paper_size
      @doc_info[:doc_type] = 'chapter'
      File.open(doc_info_path, 'w') { |f| f.write @doc_info.to_yaml}
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
