
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
# We do this by setting use_heading in style instead of specifigy font text_size
# We set use_heading: true , and we use @h1_heading_object, @h2_heading_object and so on.

module RLayout
    
  class SpreadChapter < ChapterMaker
	  attr_accessor :first_page, :second_page, :h1_heading_object, :h2_heading_object
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
      @starting_page_number = options.fetch(:starting_page_number,1)
      read_story
      layout_story
      output_options = {:preview=>true}
      @document.save_pdf(@output_path,output_options) unless options[:no_output] 
      @doc_info = {}
      @doc_info[:page_count] = @document.pages.length
      save_toc
      self
    end
    
    # markdown2spread_data reads stroy as spread_chapter format
    # markdown2spread_data is used 
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
        @story  = Story.new(@story_path).markdown2spread_data
      # elsif ext == ".adoc"
      #   @story      = Story.adoc2para_data(@story_path)
      end
      @heading    = @story[:heading] || {}
      @title      = @heading[:title] || @heading['title'] || "Untitled"
      @toc_content= "## #{@title}\t0\n"
      @first_page_paragraphs = []
      @second_page_paragraphs = []
      @paragraphs = @first_page_paragraphs
      @story[:paragraphs].each do |para|
        next if para.nil?
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        if para[:markup] == 'h1'
          @paragraphs = @first_page_heading.
          next
        elsif para[:markup] == 'h2'
          @paragraphs = second_page_paragraphs
          next
        elsif para[:markup] == 'img' && para[:string]
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
        elsif para[:markup] == 'float_group'
          @paragraphs << FloatGroup.new(para)
          next
        elsif para[:markup] == 'ordered_list'
          @paragraphs << OrderedList.new(text_block: para[:text_block])
          next
        elsif para[:markup] == 'unordered_list'
          @paragraphs << UnorderedList.new(text_block: para[:text_block])
          next
        end
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
      if first_item.is_a?(RLayout::FloatGroup) || first_item.is_a?(RLayout::PhotoPage) || first_item.is_a?(RLayout::PdfInsert)
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
        if first_item.is_a?(RLayout::FloatGroup) || first_item.is_a?(RLayout::PhotoPage) || first_item.is_a?(RLayout::PdfInsert)
          first_item = @paragraphs.shift
          first_item.layout_page(document: @document, page_index: @page_index)
        end
        @document.pages[@page_index].main_box.layout_items(@paragraphs)
        @page_index += 1
      end
      update_header_and_footer      
    end

  end
  

end