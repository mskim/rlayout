module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  # Replica of front cover image
  
  class DoviraTwo < InsideCover
    attr_reader :cover_image_path
    
    def initialize(options={} ,&block)
      @starting_page_number = options[:starting_page_number] || 1
      super
      @front_page_pdf = options[:front_page_pdf]
      page = @document.pages.last
      page.add_image(@front_page_pdf)
      @document.save_pdf(@output_path, page_pdf:@page_pdf)
      self
    end

    def default_layout_rb
      @top_margin = 50
      @left_margin = 50
      @right_margin = 50
      @bottom_margin = 50
      doc_options= {}
      doc_options[:paper_size] = @paper_size
      doc_options[:left_margin] = @left_margin
      doc_options[:top_margin] = @top_margin
      doc_options[:right_margin] = @right_margin
      doc_options[:bottom_margin] = @bottom_margin
      layout =<<~EOF
        RLayout::RDocument.new(#{doc_options})
      EOF
    end


end