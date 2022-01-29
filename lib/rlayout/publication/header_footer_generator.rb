

# This module is used to generate header and fooler in existing chapter content
# This way we can assemble books with need chapters and don't have to relayout just to put proter heade and foott.
#

module RLayout
  class HeaderAndFooter
    attr_accessor :path, :doc, :book_title, :chapter_title, :starting_page_number, :template, :template_path
    attr_accessor :doc_info
    def initilaize(options={})
      @path           = options[:path]
      @book_title     = options[:book_title]
      @chapter_title  = options[:chapter_title]
      @starting_page_number  = options[:starting_page_number]
      @template_path  = options[:template_path]
      read_template
      put_header_and_footer
      save_doc_info
      self
    end
  end

end
