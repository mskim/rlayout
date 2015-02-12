
class DocumentViewMac
  attr_accessor :title, :document, :page_views, :pdf_doc
  
  def initialize(document)
    @document   = document
    @page_views = []
    pages   = @document.pages
    if pages
      pages.each do |page|
        @page_views << GraphicViewMac.from_graphic(page)
      end
    end
    self
  end
  
  def pdf_document
    pdf_doc=PDFDocument.alloc.init
    @page_views.each_with_index do |page_view, index|
      pdf_page=PDFDocument.alloc.initWithData(page_view.pdf_data).pageAtIndex(0)
      pdf_doc.insertPage(pdf_page, atIndex:index)
    end
    pdf_doc
  end
  
  def save_pdf(path, options={})
    pdf_path=path
    unless File.extname(path) == '.pdf'
      pdf_path=path + ".pdf"
    end
    pdf_document.writeToFile(pdf_path)
    @page_views.length
  end
  
  def doc_pdf(path)
    
  end
  
  def doc_jpg(path)
    
  end
  
  def doc_thumbnail(path)
    
  end
end

