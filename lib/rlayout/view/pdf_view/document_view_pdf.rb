module RLayout

class RDocument

  attr_accessor :pdf_doc

  def save_pdf_in_ruby(path, options={})
    @pdf_doc = HexaPDF::Document.new
    @pages.each do |page|
      pdf_page = @pdf_doc.pages.add([0,0,@width,@height])
      canvas = pdf_page.canvas
      page.to_pdf(canvas)
    end
    pdf_path=path
    unless File.extname(path) == '.pdf'
      pdf_path=path + ".pdf"
    end
    @pdf_doc.write(pdf_path, optimize: true)
    # if we have jpg option, save image as basename_(i+1).jpg format
    # if we have preview option save images in /preview/page_00(i+1).jpg
    if options[:jpg] || options[:preview]
      if options[:preview]
        @preview_path = File.dirname(path) + "/preview"
        # if we have old version, clear the folder
        system("rm -r #{@preview_path}") if File.directory?(@preview_path)
        #generate new folder
        system("mkdir -p #{@preview_path}")
      end
      pdf_doc.pageCount.times do |i|
        page      = pdf_doc.pageAtIndex i
        pdfdata     = page.dataRepresentation
        image       = NSImage.alloc.initWithData pdfdata
        imageData   = image.TIFFRepresentation
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
    @pages.length
  end
end

end