module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  # Replica of front cover image
  
  class InsideCover < Chapter
    attr_reader :project_path, :cover_image_path, :starting_page
    def initialize(options={})
      @paper_size = options[:paper_size] || "A4"
      @starting_page = options[:starting_page]
      @cover_image_path = options[:cover_image_path]
      if @starting_page.even?
        @page_count = 2
      else
        @page_count = 1
      end
      
      self
    end

    def default_layout

    end
  end

end