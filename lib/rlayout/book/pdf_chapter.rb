module RLayout

  # PdfSection
  # PdfSection is used to insert pre-made pdf file into the book.
  # 1. adjust pdf size to fit, if size is different.
  # 2. relex page_number so that book page_number is 
  # used for inserting title page, blank page, designed page,
  # highly graphical page that are made with other program.
  
  # 00_blank_page
  # 01_title_page
  # 02_some_graphic_page
  # 03_book_info
  # 04_dedication
  # 05_prologue
  # 06_toc


  class PdfSection 
    attr_reader :pdf_path

    def initialize(pdf_path, options={})
      @pdf_path = pdf_path
      super

    end
  end

end