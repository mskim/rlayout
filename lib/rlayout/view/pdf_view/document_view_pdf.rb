module RLayout

class RDocument

  attr_accessor :pdf_doc

  def save_pdf_in_ruby(path, options={})
    @pdf_doc = HexaPDF::Document.new
    load_fonts(pdf_doc)
    @pages.each do |page|
      pdf_page = @pdf_doc.pages.add([0,0,@width,@height])
      canvas = pdf_page.canvas
      page.draw_pdf(canvas)
    end
    pdf_path=path
    unless File.extname(path) == '.pdf'
      pdf_path=path + ".pdf"
    end

    @pdf_doc.write(pdf_path, optimize: true)
    # if we have jpg option, save image as basename_(i+1).jpg format
    # if we have preview option save images in /preview/page_00(i+1).jpg
    # if options[:jpg] 
    #   # create jpg?
    # end
  end

  # read fonts from disk
  def load_fonts(pdf_doc)
    font_foleder = "/Users/Shared/SoftwareLab/font_width"
    Dir.glob("#{font_foleder}/*.ttf").each do |font_file|
      pdf_doc.fonts.add(font_file)
    end
  end
end

end