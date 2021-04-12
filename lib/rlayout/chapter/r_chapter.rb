# encoding: utf-8

# Chapter
# Chapter converts given Story into a document.
# Story is parsed to heading and body. 
# Each story has heading and body, heding is placed at the top in yaml format.
# Body part follows the headinng, in markdown format.
# Body part are converted to series of paragraphs,

# Heading type
# We have tow type of chapter heading, Heading and HeadingContainer.
# for growing and fix height heading.

# How to place images in long document?

# There are three ways of placing images in the long document.
# First method is to embed image markup in the text.
# This will place image in the column along other text paragraphs,
# We can set width of image as 1, 1/2, 1/3, 1/4 of column.
# And text will flow around it.

# And second way is to use float_group.
# Float_group is a floating images layout on top of a page,
# where text flows aroud those images.
# Float_group containes position information,
# such as grid_frame, size, position attributes.
# New page is triggered with Float_group. pre-desinged layout pattern can also be used.

# And the third method is to use photo_page,
# photo_page can containe more then one page.
# New page section is triggered for photo_page.
# photo_page is pure photo only page, no text flows in the page,
# no header, no footer, no page number.
# pre-desinged layout pattern can be pulled from pattern library
# or positions can be set manually.

# For short documents, such as magazine article,
# desinger can place image in rlayout file.
# And image info in specified in meta-data header
# or design template by designer.

# For book chapters, first, second and third methods are used.

# How to place image caption?
# File that has same name with extension of .caption?
# add p write after the # image tag, this should be the caption?
# Or have the caption text as file name.?
# or caption info in the image markup?

# Add Image bleeding support

# Inserting Pre-Made PDF Pages in the middle of the pages.

# new page triggering

# when we encounter page triggering node, add new page
#    section_1, photo_page, image_group


# LongDocument
# LongDocument is made to handle collection of document parts, for long document.
# Typical LongDocument parts are, title_page, section, photo_page, image_group_page.
# and pdf_insert.

# pdf_insert is pre-made pdf pages that are inserted in the middle of chapter.

# Asciidoctor
# Asciidoctor is used for creating books from Asciidoctor content.
# Asciidoctor content is parsed and broken into parts.
# Broken parts are handed to LongDocument as parts.
# LongDocument is also reponsible for generating TOC, index, and x-ref.

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


# # Section
# ## Section
# ### Section
# #### Section
# ##### Section

# section mark
# = Section
# == Section
# === Section
# ==== Section
# ===== Section

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

module RLayout

  class RChapter
    attr_reader :document_path, :story_path
    attr_reader :document, :output_path, :column_count
    attr_reader :doc_info, :toc_content
    attr_reader :book_title, :title, :starting_page, :heading_height_type, :heading
    attr_reader :body_line_count, :body_line_height
    attr_reader :max_page_number, :page_floats

    # page_by_page is used for page proof reading
    # if page_by_page is true,
    # folders are created for each page, with jpg image and, markdown text for that page
    # this allow the proofer to working on that specific page rather than dealing with entire chapter text.
    
    attr_reader :page_by_page, :story_md

    def initialize(options={} ,&block)
      @document_path   = options[:document_path]
      @story_path     = @document_path + "/story.md"
      @output_path    = options[:output_path] || @document_path + "/chapter.pdf"
      @story_md       = options[:story_md]
      @layout_rb      = options[:layout_rb]
      unless @layout_rb
        layout_path = @document_path + "/layout.rb"
        unless File.exist?(layout_path)
          @layout_rb = default_document
        else
          @layout_rb = File.open(layout_path, 'r'){|f| f.read}
        end
      end
      @page_floats    = options[:page_floats]   || []
      @starting_page  = options[:starting_page] || 1
      @page_by_page   = options[:page_by_page]
      @document       = eval(@layout_rb)
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@document} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::RDocument)
        puts "Not a @document kind created !!!"
        return
      end
      @document.starting_page = @starting_page
      # place floats to pages
      if options[:page_floats]
        @page_floats      = options.fetch(:page_floats, [])
      else
        read_page_floats 
      end
      
      if @page_floats
        page_floats_page_count = @page_floats.keys.sort.last + 1
        need_page_count = page_floats_page_count - @document.pages.length
        if need_page_count > 0
          need_page_count.times do 
            @document.add_new_page
          end
        end
        @document.pages.each_with_index do |p,i|
          page_floats = @page_floats[i]
          p.add_floats(page_floats) if page_floats
        end
      end

      # @page_floats.each_with_index do |page_float,i| 
      #   p = @document.pages[i]
      #   unless  p
      #     @document.add_new_page 
      #     p = @document.pages[i]
      #   end
      #   page_floats = @page_floats[i]
      #   p.add_floats(page_float)
      # end
      read_story
      layout_story
      @document.save_pdf(@output_path) unless options[:no_output]
      self
    end

    def default_document
      layout =<<~EOF
        RLayout::RDocument.new(page_size:'A5')
      EOF
    end

    def read_page_floats
      unless File.exists?(doc_info_path)
        puts "Can not find file #{doc_info_path}!!!!"
        return {}
      end
      @doc_info = YAML::load_file(doc_info_path)
      @page_floats = @doc_info[:page_floats]
    end

    def read_story
      if @story_md 
        @story  = Story.new(nil).markdown2para_data(source:@story_md)
      else
        @story  = Story.new(@story_path).markdown2para_data
      end
      @heading  = @story[:heading] || {}
      @title    = @heading[:title] || "Untitled"
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
          RHeading.new(@heading)
        elsif @document.pages[0].has_heading?
          @document.pages[0].get_heading.set_heading_content(@heading)
        end
      end

      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        para_options[:para_string]    = para[:para_string]
        @paragraphs << RParagraph.new(para_options)
      end
    end
    
    def layout_story
      @document.pages.each do |page|
        page.layout_floats
        page.adjust_overlapping_columns
        page.set_overlapping_grid_rect
        page.update_column_areas
      end
      @first_page               = @document.pages[0]
      @current_line             = @first_page.first_text_line
      while @paragraph = @paragraphs.shift
        # last_page     = @current_line.parent
        @current_line = @paragraph.layout_lines(@current_line)
        unless @current_line
          # retruns first_text_line
          @current_line = @document.add_new_page
        end
      end
    end

    def next_chapter_starting_page
      @starting_page = 1 if @starting_page.nil?
      @page_view_count = 0   if @page_view_count.nil?
      @starting_page + @page_view_count
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
      toc_path        = @document_path + "/doc_info.yml"
      @doc_info[:page_size] = @page_size
      @doc_info[:toc] = @toc_content
      File.open(toc_path, 'w') { |f| f.write @doc_info.to_yaml}
    end
  end
end
