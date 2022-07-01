
module RLayout
  class WingAuthor
    attr_reader :document_path, :info_text, :isbn_text
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    
    include Styleable

    def initialize(options={})

      @document_path = options[:document_path]
      @style_guide_folder = options[:style_guide_folder] || @document_path
      @output_path = @document_path + "/output.pdf"
      @starting_page_number = options[:starting_page_number] || 1
      @page_pdf = options[:page_pdf] || true
      @width = options[:width]
      @height = options[:height]
      @left_margin = options[:left_margin]
      @top_margin = options[:top_margin] 
      @right_margin = options[:right_margin]
      @bottom_margin = options[:bottom_margin]
      @jpg = options[:jpg] || false
      load_doc_style
      @document.save_pdf(@output_path, jpg: @jpg)
      self
    end

    def default_layout
      =<<~EOF
      RLayout::RColumn.new(widht:#{@width}, #{@height}) do
        personal_image(local_path:'#{@author}.jpg')
      end
  
      EOF
  
    end
    
  end
end