
class DocumentViewMac
  attr_accessor :title, :document, :page_views, :pdf_doc
  
  def initialize(document)
    @document   = document
    @page_views = []
    @document.pages.each do |page|
      @page_views << GraphicViewMac.from_graphic(page)
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
    pdf_doc = pdf_document
    pdf_doc.writeToFile(pdf_path)
    if options[:jpg]
      pdf_doc.pageCount.times do |i|
        page      = pdf_doc.pageAtIndex i
        pdfdata     = page.dataRepresentation
        image       = NSImage.alloc.initWithData pdfdata
        imageData   = image.TIFFRepresentation
        imageRep    = NSBitmapImageRep.imageRepWithData(imageData)  
        imageProps  = {NSImageCompressionFactor=> 1.0}
        imageData   = imageRep.representationUsingType(NSJPEGFileType, properties:imageProps)
        jpg_path    = pdf_path.sub(".pdf", "_#{i+1}.jpg")
        imageData.writeToFile(jpg_path, atomically:false)
      end
    end
    @page_views.length
  end
  
end

