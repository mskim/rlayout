module RLayout

  # TODO
  # hande two page part_cover
  class PartCover < StyleableDoc
    attr_reader :book, :project_path, :title, :order

    def initialize(options={})
      super
      # @project_path = options[:project_path]
      # @starting_page_number = options[:starting_page_number] || 1
      # @paper_size = options[:paper_size] || 'A5'
      # @width = SIZES[@paper_size][0]
      # @height = SIZES[@paper_size][1]
      @page_count = options[:page_count] || 1
      @title = options[:title] || 'The Name of the Part'
      @order = options[:order] || '01'
      @order_string = options[:order_string] || '01'
      @title = options[:title] || 'The Name of the Part'
      # generate_pdf
      # save_toc
      @document.save_pdf(output_path, page_pdf:true, jpg:true)
    end

    def output_path
      @document_path + "/chapter.pdf"
    end

    # # TODO 
    # def page_count
    #   1
    # end

    def layout_options
      h = {}
      h[:document_path] = @document_path  
      h[:width] = @width
      h[:height] = @height
      # h[:fill_color] = 'blue'
      h[:fill_color] = 'cyan'
      h[:toc]        = true
      h
    end

    def default_layout_rb
      s =<<~EOF
      RLayout::Container.new(#{layout_options}) do
        text("#{@order}부 ", font_size:#{20}, x: 100, y: 200, width:200, text_alignment: "right")
        text("#{@title}", font_size:#{18}, x: 100, y: 250, width:200, text_alignment: "right")
      end
  
      EOF
    end

    # def layout_template
    #   s =<<~EOF
    #   RLayout::Container.new(#{layout_options}) do
    #     text("#{@order}부 ", font_size:#{20}, x: 100, y: 200, width:200, text_alignment: "right")
    #     text("#{@title}", font_size:#{18}, x: 100, y: 250, width:200, text_alignment: "right")
    #   end
  
    #   EOF
    # end

    # def layout_path
    #   @project_path + "/layout.rb"
    # end

    # def pdf_path
    #   @project_path + "/chapter.pdf"
    # end

    # def generate_pdf
    #   FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
    #   r = eval(layout_template)
    #   r.save_pdf_with_ruby(pdf_path, page_pdf:true, jpg:true)
    # end

    def save_toc
      toc_path = @project_path + "/toc.yml"
      @toc_content = []
      toc_item = {}
      toc_item[:page] = @starting_page_number
      toc_item[:markup] = 'h1'
      toc_item[:para_string] = @title
      @toc_content << toc_item
      File.open(toc_path, 'w') { |f| f.write @toc_content.to_yaml}
    end
  end

end