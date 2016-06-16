# encoding: utf-8

# ChapterMaker merges Story and Document into a  chapter.
# deprecated **** Story can come from couple of sources, markdown, adoc, or html(URL blog)
# deprecated **** Story can be .story, adoc, markdown, or html format.
# Story file format is our own, mixture of adoc, markdown and LaTex.

# Stories are first converted to para_data format, 
# It is also converted to Asciidoctor or GHF-markdown for HTML generation. 

# ChapterMaker loads custom template from local folder, or default template from library location. 
# ChapterMaker loads custom styles from local folder, or default style from library location.

# How to place images in long document?
# There are three ways of placing images in the long document.
# First method is to embed image markup in the text.
# This will place image in the column along other text paragraphs, 
# We can set width of image as 1, 1/2, 1/3, 1/4 of column.
# And text will flow around it.
# The second way is to use image_group.
# Image markup shoud containe position information, such as grid_frame, size, position attributes.
# New page is triggered for this case. pre-desinged layout pattern can also be used.
# Images are layed on top as floating images allowing text to flow around it.
# And the third method is to use photo_page, it is similar to image_group, but no text.
# New page is triggered for photo_page.
# photo_page is pure photo only page, no text paragraph is layed out, no header, no footer, no page number.
# pre-desinged layout pattern can be pulled from pattern library or positions can be set manually.

# For book chapters, first, sencod and third methods are used.

# For short documents, such as magazine article, second choice is used. 
# And image info in specified in meta-data header or design template by designer.


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
# story file should conain minimum markup.
# I should transform them into Asciidoctor, LqTex, or markdown format.
# And it shold be simple.
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

# section mark
# = Section
# == Section
# === Section
# ==== Section
# ===== Section

# # Section
# ## Section
# ### Section
# #### Section
# ##### Section

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

# class String
#   def blank?
#     !include?(/[^[:space:]]/)
#   end
# end

module RLayout

  class ChapterMaker
    attr_accessor :project_path, :template_path, :story_path
    attr_accessor :document, :output_path, :starting_page_number, :column_count

    def initialize(options={} ,&block)
      @project_path = options[:project_path] || options[:article_path]
      if @project_path
        @story_path = Dir.glob("#{@project_path}/*.{md,markdown}").first
      elsif options[:story_path]
        @story_path = options[:story_path]
        unless File.exist?(@story_path)
          puts "No story_path doen't exist !!!"
          return
        end
        @project_path = File.dirname(@story_path)
      end
      $ProjectPath  = @project_path
      
      if options[:output_path]
        @output_path = options[:output_path]
      else
        ext = File.extname(@story_path)
        @output_path = @story_path.gsub(ext, ".pdf")
      end
      
      if options[:template_path] && File.exist?(options[:template_path])
        @template_path = options[:template_path]
      else
        @template_path = Dir.glob("#{@project_path}/*.{rb,script,pgscript}").first
      end
      unless @template_path
        @template_path = options.fetch(:template_path, "/Users/Shared/SoftwareLab/article_template/chapter.rb")
      end
      template = File.open(@template_path,'r'){|f| f.read}
      @document = eval(template)
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@template_path} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::Document)
        puts "Not a @document kind created !!!"
        return
      end
      @starting_page_number = options.fetch(:starting_page_number,1)
      read_story
      layout_story
      output_options = {:preview=>true}
      @document.save_pdf(@output_path,output_options) unless options[:no_output] 
      self
    end
        
    def read_story
      ext = File.extname(@story_path)
      if ext == ".md" || ext == ".markdown" || ext == ".story"
        @story      = Story.markdown2para_data(@story_path)
      # elsif ext == ".adoc"
      #   @story      = Story.adoc2para_data(@story_path)
      end
      @heading    = @story[:heading] || {}
      @title      = @heading[:title] || "Untitled"
      @paragraphs =[]
      @story[:paragraphs].each do |para|
        next if para.nil?
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        if para[:markup] == 'img'
          para_options.merge!(eval(para[:string]))
          @paragraphs << Image.new(para_options)
          next
        elsif para[:markup] == 'table'
          #TODO
          @paragraphs << Table.new(para)
          next
        elsif para[:markup] == 'photo_page'
          @paragraphs << PhotoPage.new(para)
          next
        elsif para[:markup] == 'image_group'
          @paragraphs << ImageGroup.new(para)
          next
        elsif para[:markup] == 'pdf_insert'
          @paragraphs << PdfInsert.new(para)
          next
        end
        # 
        # if para[:markup].blank?
        #   puts "empty paragraph"
        #   next
        # else
        # end
          
        # para_options[:text_string]    = para[:string]
        # para_options[:text_string]    = para[:string]
        # para_options[:article_type]   = @article_type
        # para_options[:text_fit]       = FIT_FONT_SIZE
        # para_options[:layout_lines]   = false
        para_options[:para_string]    = para[:string]
        if para[:string].nil?
          puts "we have para[:string].nil?"
        end
        @paragraphs << Paragraph.new(para_options) unless para[:string].nil?
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
      if first_item.is_a?(RLayout::ImageGroup) || first_item.is_a?(RLayout::PhotoPage) || first_item.is_a?(RLayout::PdfInsert)
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
          options[:page_number] = @starting_page_number + @page_index
          options[:column_count]= @document.column_count
          p=Page.new(options)
          p.relayout!
          p.main_box.create_column_grid_rects
        end
        if @document.pages[@page_index].main_box.nil?
          @document.pages[@page_index].main_text
          @document.pages[@page_index].relayout!
        end
        first_item = @paragraphs.first
        if first_item.is_a?(RLayout::ImageGroup) || first_item.is_a?(RLayout::PhotoPage) || first_item.is_a?(RLayout::PdfInsert)
          first_item = @paragraphs.shift
          first_item.layout_page(document: @document, page_index: @page_index)
        end
        @document.pages[@page_index].main_box.layout_items(@paragraphs)
        @page_index += 1
      end
      update_header_and_footer      
    end

    def next_chapter_starting_page_number
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
    # generate layout.rb file with script in each page
    # for manual image adjusting
    def generate_layout
      @page_content = ""
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
        @image_layout = ""
        page.floats.each do |float|
          @image_layout += float.to_script
        end
        @page_content += page_text
      end
      layout_file = layout_text
      File.open(layout_path, 'w'){|f| f.write layout_file}
    end    
  end
  
  class PhotoPage < Page
    attr_accessor :image_group
    def initialize(options={})
      @image_group = options[:image_group]
      super
      self
    end
    # page layout is delayed until layout time.
    # document is not known until layout time.
    def layout_page(options={})
      puts __method__
      @document = options[:document]
      adjust_page_size_to_document
      @image_group  = options[:image_group]
      @image_group.each do |image_info|
        float_image(image_info)
      end
      1 # page index
    end
    
  end
  
  # Challenges with ImageGroup
  # Image_group puts an image at current page if image group is the first item, text_box.exmpty?==true
  # else it puts image at the following page, adding page if the page doen't exist. 
  # for the second case we could get unwanted space between the previous paragraph and next page image.
  # since we don't know where the exact breaking point is.
  # We want the folliwing paragraphs to fill into the previous page's space before the image, if we have room.

  # 1. allow_text_jump_over
  # this is where "allow_text_jump_over" is used
  # it tells to allow following text to jump over and fill the gap in previous page of the image.
  
  # 2. page_offset?? not implemented yet we could do this we multipe image_group
  # if image is specified with page_offset starting from next page, 
  # image is place ot offsetting page
  # This is used to layout image that are certain pages apart.
	# {local_image: "1.jpg", frame_rect: [0,0,1,1]}
	# {local_image: "2.jpg", frame_rect: [0,0,1,1], page_offset:1}
	# {local_image: "3.jpg", frame_rect: [0,0,1,1], page_offset:2}
	
	# above will page images in following page 1, 2, 3

  class ImageGroup
    attr_accessor :image_group, :allow_text_jump_over
    def initialize(options={})
      options[:allow_text_jump_over] = true
      @allow_text_jump_over = options[:allow_text_jump_over] if options[:allow_text_jump_over]
      @image_group = eval(options[:string])
      super
      self
    end
    
    # page layout is delayed until layout time.
    # document is not known until layout time.
    def layout_page(options={})
      @document     = options[:document]
      @page_index   = options[:page_index]
      @starting_page_number = options.fetch(:@starting_page_number, 1)
      @page         = @document.pages[@page_index]
      @main_box     = @page.main_box
      if @main_box.empty?
        # put image group in empty main_box
      else
        # go to next page
        @page_index += 1
        # make page, if it is the last page
        if @page_index >= @document.pages.length
          options               = {}
          options[:parent]      = @document
          options[:footer]      = true
          options[:header]      = true
          options[:text_box]    = true
          options[:page_number] = @starting_page_number + @page_index
          options[:column_count]= @document.column_count
          p=Page.new(options)
          p.relayout!
          p.main_box.create_column_grid_rects
          @main_box = p.main_box
        end
      end
      # adjust_page_size_to_document 
      @image_group.each do |image_info|
        @main_box.float_image(image_info)
      end
      @main_box.layout_floats!
      @main_box.set_overlapping_grid_rect
      @main_box.update_column_areas
    end
    
  end
  
  # we are given pdf in the middle of the document
  # create pages that con
  class PdfInsert
    attr_accessor :layout_info
    def initialize(options={})
      super
      self
    end
    # page layout is delayed until layout time.
    # document is not known until layout time.
    def layout_page(options={})
      @document = options[:document]
      #TODO
      # create pages with PDF as Page and insert it to document
      # return PdfInsert.length
    end
        
  end
end
