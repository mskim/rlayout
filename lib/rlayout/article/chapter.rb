# encoding: utf-8

# Chapter
# Chapter combines Story and Document into a  chapter.
# Story can come from couple of sources, markdown, adoc, or html(URL blog)
# deprecated **** Story can be .story, adoc, markdown, or html format.
# Story file format is our own, mixture of adoc, markdown and LaTex.
# Stories are first converted to para_data format,
# It is also converted to Asciidoctor or GHF-markdown for HTML generation.
# Chapter first look for template in local folder,
# if it is not found, takes default template from library location.

# How to place images in long document?
# There are three ways of placing images in the long document.
# First method is to embed image markup in the text.
# This will place image in the column along other text paragraphs,
# We can set width of image as 1, 1/2, 1/3, 1/4 of column.
# And text will flow around it.
# The second way is to use float_group.
# float_group markup shoud containe position information,
# such as grid_frame, size, position attributes.
# New page is triggered. pre-desinged layout pattern can also be used.
# Images and floats are layed on top as floats allowing text to flow around it.
# And the third method is to use photo_page,
# it is similar to image_group, but no text flowing.
# New page is triggered for photo_page.
# photo_page is pure photo only page, no text paragraph is layed out,
# no header, no footer, no page number.
# pre-desinged layout pattern can be pulled from pattern library
# or positions can be set manually.

# For short documents, such as magazine article,
# desinger can place image in rlayout file.
# And image info in specified in meta-data header
# or design template by designer.

# For book chapters, first, sencod and third methods are used.

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

# LongDocument is used for creating books from Asciidoctor content.
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

module RLayout

  class Chapter
    attr_accessor :project_path, :template_path, :story_path
    attr_accessor :document, :output_path, :column_count
    attr_accessor :doc_info, :toc_content
    attr_reader :book_title, :title, :starting_page

    def initialize(options={} ,&block)
      @project_path = options[:project_path] || options[:article_path]
      if @project_path
        @story_path = Dir.glob("#{@project_path}/*.{md,markdown}").first
      elsif options[:story_path]
        @story_path = options[:story_path]
        unless File.exist?(@story_path)
          puts "No story found at #{@story_path} !!!"
          return
        end
        @project_path = File.dirname(@story_path)
      end
      $ProjectPath  = @project_path
      if options[:output_path]
        @output_path = options[:output_path]
      elsif options[:filename_output]
        ext = File.extname(@story_path)
        @output_path = @story_path.gsub(ext, ".pdf")
      else
        @output_path = @project_path + "/output.pdf"
      end
      if options[:template_path] && File.exist?(options[:template_path])
        @template_path = options[:template_path]
      else
        @template_path = Dir.glob("#{@project_path}/*.{rb,script,pgscript}").first
      end
      unless @template_path
        @template_path = options.fetch(:template_path, "/Users/Shared/SoftwareLab/document_template/paperback/chapter/layout.rb")
      end
      template = File.open(@template_path,'r') { |f| f.read}
      @document = eval(template)
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@template_path} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::Document)
        puts "Not a @document kind created !!!"
        return
      end
      @starting_page = options.fetch(:starting_page,1)
      doc_info_path = @project_path + "/doc_info.yml"
      if File.exist?(doc_info_path)
        yaml = File.open(doc_info_path, 'r'){|f| f.read}
        @doc_info = YAML::load(yaml)
        @starting_page = @doc_info[:starting_page]
      else
        @doc_info = {}
      end
      @document.starting_page = @starting_page
      @document.pages.each_with_index do |page, i|
        page.page_number = @starting_page + i
      end
      read_story
      layout_story
      output_options = {preview: true}
      @document.save_pdf(@output_path,output_options) unless options[:no_output]
      @doc_info[:starting_page] = @starting_page
      @doc_info[:page_count] = @document.pages.length
      save_toc
      self
    end

    def read_story
      ext = File.extname(@story_path)
      if ext == ".md" || ext == ".markdown" || ext == ".story"
        @story  = Story.new(@story_path).markdown2para_data
        # elsif ext == ".adoc"
        # @story      = Story.adoc2para_data(@story_path)
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
      heading_object.parent_graphic = @first_page
      unless @first_page.main_box
        @first_page.main_text
      end
      @first_page.relayout!
      @first_page.main_box.create_column_grid_rects
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
