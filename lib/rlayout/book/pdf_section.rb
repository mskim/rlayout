module RLayout

  # PdfSection
  # PdfSection is used to insert pre-made pdf file into the book.
  # It is  used for inserting title_page or highly graphical PDF files that are made with other programs.
  # This is also used in Magazine to insert pre-made Ad pages.
  # It is even used with entire pre-made PDF book to create ebook.
  
  # If souce folder has only pdf file, it is assumed that it is pre-designed PdfSection.
  # If souce folder has only doc_info.yml. it creates PdfSection with empty pages.

  # 1. Adjust pdf size to fit with rest of the book, if inserting PDF size is different than the book.
  # 2. Adjust page_numbers of following book sections. 
  # 3. Create empty pages. 

  # example FrontMatter
  # 00_blank_page
  #   doc_info.yml 
  #    page_type: blank, or note for note style lines
  #    page_count: 1  , or 2,3 
  # 01_title_page
  #    title_page.pdf
  # 02_some_graphic_page
  #    some_graphical.pdf
  # 03_book_info
  #    book_info.pdf
  # 04_dedication
  # 05_prologue
  # 06_toc

  class PdfSection 
    attr_reader :section_folder, :pdf_path
    attr_reader :pdf_doc, :width, :height, :doc_info, :page_count
    attr_reader :paper_size, :width, :height
    attr_reader :original_page_width, :original_page_height

    def initialize(section_folder, options={})
      @section_folder = section_folder
      @paper_size = options[:paper_size] || 'A5'
      @width = SIZES[@paper_size][0]
      @height = SIZES[@paper_size][1]
      section_file = Dir.glob("#{@section_folder}/*[.pdf,.yml,.yaml]").first
      if section_file =~/.pdf$/
        @pdf_path = File.expand_path(section_file)
        @pdf_doc = HexaPDF::Document.open(@pdf_path)
        @original_page_width = @pdf_doc.pages[0].box.width
        @original_page_height = @pdf_doc.pages[0].box.height
        adjust_pdf_size
        # RLayout::split_pdf(@pdf_path)
      elsif section_file =~/.yml$/ || section_file =~/.yaml$/
        @doc_info = YAML::load_file(section_file)
        create_blank_page_pdf
      else
        puts "No PDF file or doc_info file found!!!"
        create_blank_page_pdf
      end
      self
    end

    # TODO:
    def adjust_pdf_size

    end

    def create_blank_page_pdf
      if  @doc_info
        @page_count = @doc_info[:page_count] || 1
        @page_type = @doc_info[:page_type] || 'blank'
      else
        @page_count = 1
        @page_type ='blank'
      end
      @pdf_doc = HexaPDF::Document.new
      @page_count.times do
        @pdf_doc.pages.add([0, 0, @width, @height])
      end
      @pdf_path = @section_folder + "/blank.pdf"
      # doc.write("boxes.pdf", optimize: true)
      @pdf_doc.write(@pdf_path, optimize: true)
      # split_pdf 
    end
  end

end