# encoding: utf-8

# Chapter
# Chapter combines Story and Document into a  chapter.
# Story can come from couple of sources, markdown, hangul, or html(URL blog)
# Stories are first converted to heading and body part.
# Body part is then converted to series of paragraphs,
# Chapter first look for template in local folder,
# if it is not found, takes default template from library location.

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

# heading_type
#   fixed height: use HeightContent
#   growing height: use Heading

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
    attr_accessor :project_path, :template_path, :story_path
    attr_accessor :document, :output_path, :column_count
    attr_accessor :doc_info, :toc_content
    attr_reader :book_title, :title, :starting_page, :heading_type, :heading
    attr_accessor :body_line_count, :body_line_height

    # page_by_page is used for page proof reading
    # if page_by_page is true,
    # folders are created for each page, with jpg image and, markdown text for that page
    # this allow the proofer to working on that specific page rather than dealing with entire chapter text.
    attr_reader :page_by_page, :story_body

    def initialize(options={} ,&block)
      @output_path    = options[:output_path]
      @project_path   = File.dirname(@output_path)
      @story_body     = options[:story_body]
      @layout_rb      = options[:layout_rb]
      @page_floats    = options[:page_floats] 
      @starting_page  = options[:starting_page] || 1
      @page_by_page   = options[:page_by_page]
      puts @layout_rb
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
      # @document.pages.each_with_index do |page, i|
      #   page.page_number = @starting_page + i
      # end
      @document.add_new_page
      binding.pry
      read_story
      layout_story
      output_options = {preview: true}
      @document.save_pdf(@output_path,output_options) unless options[:no_output]
      @doc_info[:starting_page] = @starting_page
      @doc_info[:page_count]    = @document.pages.length
      save_toc
      # @document.save_page_by_page(@project_path) if page_by_page
      self
    end

    def read_story
      if @story_body 
        para_data = Story.body2para_data(@story_body, starting_heading_level=1)
        @paragraphs = para_data.map do |para|
          RParagraph.new(para)
        end
      else
        @story  = Story.new(@story_path).markdown2para_data
      end
    end
    
    def layout_story
      @page_index               = 0
      @first_page               = @document.pages[0]
      @current_line = @first_page.first_line
      while @paragraph = @paragraphs.shift
        binding.pry unless @current_line.class == RLayout::RLineFragment
        @current_line = @paragraph.layout_lines(@current_line)
        unless @current_line
          @current_line = @document.add_new_page
        end
      end
    end


    def next_chapter_starting_page
      @starting_page = 1 if @starting_page.nil?
      @page_view_count = 0   if @page_view_count.nil?
      @starting_page + @page_view_count
    end

    def save_doc_info
      doc_info_path   = @project_path + "/doc_info.yml"
      @doc_info[:toc] = @toc_content
      @doc_info[:toc] = @toc_content
      File.open(toc_path, 'w') { |f| f.write e@doc_info.to_yaml}
    end

    def save_toc
      @project_path   = File.dirname(@output_path)
      toc_path        = @project_path + "/doc_info.yml"
      @doc_info[:page_size] = @page_size
      @doc_info[:toc] = @toc_content
      File.open(toc_path, 'w') { |f| f.write @doc_info.to_yaml}
    end

  end
end
