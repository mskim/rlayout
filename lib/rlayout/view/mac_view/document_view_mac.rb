
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
    pdf_doc = PDFDocument.alloc.init
    @page_views.each_with_index do |page_view, index|
      pdf_page=PDFDocument.alloc.initWithData(page_view.pdf_data).pageAtIndex(0)
      pdf_doc.insertPage(pdf_page, atIndex:index)
    end
    pdf_doc
  end

  def save_pdf(path, options={})
    puts "in save_pdf"
    pdf_path=path
    unless File.extname(path) == '.pdf'
      pdf_path=path + ".pdf"
    end
    pdf_doc = pdf_document
    pdf_doc.writeToFile(pdf_path)
    # if we have jpg option, save image as basename_(i+1).jpg format
    # if we have preview option save images in /preview/page_00(i+1).jpg
    if options[:jpg] || options[:preview]
      puts "options[:jpg]:#{options[:jpg]}"
      if options[:preview]
        @preview_path = File.dirname(path) + "/preview"
        # if we have old version, clear the folder
        system("rm -r #{@preview_path}") if File.directory?(@preview_path)
        #generate new folder
        system("mkdir -p #{@preview_path}")
      end
      pdf_doc.pageCount.times do |i|
        page        = pdf_doc.pageAtIndex i
        page_size   = page.page_size
        pdfdata     = page.dataRepresentation
        image       = NSImage.alloc.initWithData pdfdata
        imageData   = image.TIFFRepresentation
        imageData   = high_res.TIFFRepresentation
        imageRep    = NSBitmapImageRep.imageRepWithData(imageData)
        imageProps  = {NSImageCompressionFactor=> 1.0}
        imageData   = imageRep.representationUsingType(NSJPEGFileType, properties:imageProps)
        if options[:preview]
          jpg_path  =  @preview_path + "/page_#{(i+1).to_s.rjust(3,'0')}.jpg"
        else
          jpg_path  = pdf_path.sub(".pdf", "_#{(i+1).to_s.rjust(3,'0')}.jpg")
        end
        imageData.writeToFile(jpg_path, atomically:false)
      end
    end
    @page_views.length
  end

end
