

# TOCChapter is a special chapter for Table Of Content
# Using TocTable, not TextBox
# It work similar to other chapter layout, read toc.md and layout them out on pages.

module RLayout

  class TOCChapter
	  attr_accessor :project_path, :toc_path, :document
    def initialize(options={} ,&block)
      @project_path = options[:project_path]
      if @project_path
        @toc_path = Dir.glob("#{@project_path}/*.{md,markdown}").first
        unless @toc_path
           puts "No toc_path!!!"
           return
        end
      elsif options[:toc_path]
        @toc_path = options[:toc_path]
        unless File.exist?(@toc_path)
          puts "No toc_path doen't exist !!!"
          return
        end
        @project_path = File.dirname(@toc_path)
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
        @template_path = options.fetch(:template_path, "/Users/Shared/SoftwareLab/document_template/toc/layout.rb")
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
      # @starting_page_number = options.fetch(:starting_page_number,2)
      # @document.starting_page_number = @starting_page_number
      read_toc
      layout_toc
      output_options = {:preview=>true}
      @document.save_pdf(@output_path, output_options) unless options[:no_output]
      @doc_info = {}
      @doc_info[:page_count] = @document.pages.length
      self
    end

    def read_toc
      ext = File.extname(@toc_path)
      if ext == ".md"
        @story  = Story.new(@toc_path).markdown2para_data
      end
      @heading    = @story[:heading] || {}
      # moption-yaml return Array unlike YAML
      @heading = @heading[0] if @heading.class == Array
      # @story[:paragraphs].each do |para|
      #   next if para.nil?
      #   para[:layout_expand]  = [:width]
      #   if para[:markup] == 'img' && para[:string]
      #     para.merge! eval(para.delete(:string))
      #     @paragraphs << Image.new(para)
      #   elsif para[:markup] == 'ordered_list'
      #     @paragraphs << OrderedList.new(para)
      #   elsif para[:markup] == 'ordered_section'
      #     @paragraphs << OrderedSection.new(para)
      #   elsif para[:markup] == 'ordered_upper_alpha_list'
      #       @paragraphs << UpperAlphaList.new(para)
      #   elsif para[:markup] == 'unordered_list'
      #     @paragraphs << UnorderedList.new(para)
      #   else
      #     @paragraphs << Paragraph.new(para)
      #   end
      # end
    end

    def layout_toc
      @page_index               = 0
      @first_page               = @document.pages[0]
      unless @first_page.main_box
        @first_page.main_text
      end
      page_index = 0
      @first_page.relayout!
      # @first_page.main_box.create_column_grid_rects
      # @first_page.main_box.set_overlapping_grid_rect
      # main_box type is toc_box
      # sending row @story[:paragraphs], not Paragraphs
      @first_page.main_box.layout_items(@story[:paragraphs])
      page_index += 1
      # for toc , do not add pages even if we have overflowing paragraphs
      while @story[:paragraphs].length > 0 && page_index < @document.pages.length
        @document.pages[page_index].main_box.layout_items(@story[:paragraphs])
        page_index += 1
      end
      # update_header_and_footer
    end


  end


end
