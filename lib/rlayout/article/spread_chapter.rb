
# SectionChapter is a special chapter composed of section pages
# It is used in document composed of pages with section headings.
# Sections are seperated by section mark "## " /^##\d\s/
# markdown2section_data is called to parse and collect para data by sections, each headed with heading Hash. markdown2section_data returns an array with data for each section. First element of those array contains Heading element.

# SpreadChapter is a chapter made of Spread, two pages
# we want to make sure that they remain as two page document.
# Story is given with a format with two page content
# Story has heading content.
# spread_content[0]
# spread_content[0][:heading]
# spread_content[1]
# spread_content[1][:heading]

# Using chapter_heading and section_heading instead of Paragraph
# There are times when we want to use Heading rather than a Paragraph.
# We do this by setting use_heading in style instead of specifigy font font_size
# We set use_heading: true , and we use @h1_heading_object, @h2_heading_object and so on.

# we need to create Heading from markdown

# markup2heading_key_map
# ["number", "title", "subtitle", "leading"] defined in style of h1
# = 03
# Some title
# some subtitle
# leading text is here

# ["title", "subtitle"] defined in style of h2
# =+ Some title
# Answer in page 2

# abpve markup text will be translated to Chapter Heading

#
module RLayout

  class SpreadChapter < Chapter
	  attr_accessor :first_page, :second_page, :h1_heading_object, :h2_heading_object, :sections_paragraph
	  attr_reader :book_title, :title
    def initialize(options={} ,&block)
      @project_path = options[:project_path] || options[:article_path]
      if @project_path
        @story_path = Dir.glob("#{@project_path}/*.{md,markdown}").first
        unless @story_path
           puts "No story_path!!!"
           return
        end
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
        @output_path = @project_path + "/output.pdf"
      end
      if options[:template_path] && File.exist?(options[:template_path])
        @template_path = options[:template_path]
      else
        @template_path = "#{@project_path}/layout.rb"
      end
      unless @template_path
        @template_path = options.fetch(:template_path, "/Users/Shared/SoftwareLab/article_template/spread_chapter.rb")
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
      @starting_page = options.fetch(:starting_page,2)
      @document.starting_page = @starting_page
      read_story
      layout_story
      output_options = {:preview=>true}
      @document.save_pdf(@output_path, output_options) unless options[:no_output]
      @doc_info = {}
      @doc_info[:page_count] = @document.pages.length
      save_toc
      self
    end

    # markdown2section_data reads stroy by section
    # markdown2section_data is used
    # Story is read with a format with two page content
    # Story has heading content.
    # story[0]
    # first_page_heading = story[:first][0]
    # story[1]
    # second_page_heading = story[:second][0]

    def read_story
      ext = File.extname(@story_path)
      if ext == ".md" || ext == ".markdown" || ext == ".story"
        # @story  = Story.new(@story_path).markdown2para_data
        @story  = Story.new(@story_path).markdown2section_data
      # elsif ext == ".adoc"
      #   @story      = Story.adoc2para_data(@story_path)
      end
      @heading    = @story[:heading] || {}
      # moption-yaml return Array unlike YAML
      @heading = @heading[0] if @heading.class == Array
      @book_title     = @heading[:book_title] || @heading['book_title'] || "Untitled"
      @title  = @heading[:title] || @heading['title'] || "Untitled"
      @toc_content= "## #{@title}\t0\n"
      @sections_paragraph = []
      @story[:sections_paragraph].each do |section|
        current_section_paragraph = []
        section.each do |para|
          next if para.nil?
          para[:layout_expand]  = [:width]
          if para[:markup]    == 'h1'
            current_section_paragraph << para
          elsif para[:markup] == 'h2'
            current_section_paragraph << para
          elsif para[:markup] == 'img' && para[:string]
            para.merge! eval(para.delete(:string))
            current_section_paragraph << Image.new(para)
          elsif para[:markup] == 'table'
            current_section_paragraph << Table.new(para)
          elsif para[:markup] == 'float_group'
            current_section_paragraph << FloatGroup.new(para)
          elsif para[:markup] == 'ordered_list'
            current_section_paragraph << OrderedList.new(para)
          elsif para[:markup] == 'ordered_section'
            current_section_paragraph << OrderedSection.new(para)
          elsif para[:markup] == 'ordered_upper_alpha_list'
              current_section_paragraph << UpperAlphaList.new(para)
          elsif para[:markup] == 'unordered_list'
            current_section_paragraph << UnorderedList.new(para)
          else
            current_section_paragraph << Paragraph.new(para)
          end
        end
        @sections_paragraph << current_section_paragraph
      end
    end

    def layout_story
      @page_index               = 0
      @first_page               = @document.pages[0]
      if heading = @first_page.has_heading?
        @first_page_heading = @first_page.heading_object
      else
        @heading[:layout_expand] = [:width, :height]
        heading_object           = Heading.new(@heading)
        @first_page.graphics.unshift(heading_object)
        heading_object.parent = @first_page
      end
      unless @first_page.main_box
        @first_page.main_text
      end
      @first_page.relayout!
      @first_page.main_box.create_column_grid_rects
      @first_page.main_box.set_overlapping_grid_rect
      first_section_paragraph = @sections_paragraph.first
      first_item = first_section_paragraph.first
      if first_item.is_a?(Hash) && @first_page_heading
        @first_page_heading.set_content(first_item)
        first_item = first_section_paragraph.shift
      elsif first_item.is_a?(RLayout::FloatGroup)
        first_item.layout_page(document: @document, page_index: @page_index)
        first_item = first_section_paragraph.shift
      end
      @first_page.main_box.layout_items(first_section_paragraph)
      @sections_paragraph.shift
      # now go for the second page
      @page_index = 1
      @sections_paragraph.each  do |section_paragraphs|
        if section_paragraphs.first.class == Hash
          heading = section_paragraphs.shift
          # layout heading
        end
        while section_paragraphs.length > 0
          if @page_index >= @document.pages.length
            options               = {}
            options[:parent]      = @document
            options[:footer]      = true
            options[:header]      = true
            options[:text_box]    = true
            options[:page_number] = @starting_page + @page_index
            options[:column_count]= @document.column_count
            p=Page.new(options)
            p.relayout!
            p.main_box.create_column_grid_rects
          end
          if @document.pages[@page_index].main_box.nil?
            @document.pages[@page_index].main_text
            @document.pages[@page_index].relayout!
          end
          first_item = section_paragraphs.first
          # if first_item.is_a?(RLayout::FloatGroup)
          #   first_item = paragraphs.shift
          #   first_item.layout_page(document: @document, page_index: @page_index)
          # end
          @document.pages[@page_index].main_box.layout_items(section_paragraphs)
          @page_index += 1
        end
      end
      update_header_and_footer
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
  end


end
