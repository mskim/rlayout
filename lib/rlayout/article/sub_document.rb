
# PdfSection is used to merge PDF document into publication
# Header, Footer, SideBar,Eraser, and Decoration,  can be generated

# PhotoPage 


module RLayout
  
  class PhotoPage < Page
    attr_accessor :image_group
    def initialize(options={})
      @image_group = options[:image_group]
      super
      self
    end
    # page layout is delayed until layout time.
    # document is not known until layout time.
    def layout_page(options={})
      @document = options[:document]
      adjust_page_size_to_document
      @image_group  = options[:image_group]
      @image_group.each do |image_info|
        float_image(image_info)
      end
      1 # page index
    end
  end
  
  class PdfSection < Document
    attr_accessor :starting_page_number, :section_title
    
    
  end
  
  # we are given pdf in the middle of the document
  # create pages that con
  class PdfInsert
    attr_accessor :layout_info
    def initialize(options={})
      super
      self
    end
    # page layout is delayed until layout time.
    # document is not known until layout time.
    def layout_page(options={})
      @document = options[:document]
      #TODO
      # create pages with PDF as Page and insert it to document
      # return PdfInsert.length
    end
        
  end
  
end