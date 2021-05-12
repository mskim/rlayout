module RLayout

  class RDocument
    attr_accessor :pdf_doc

    def save_pdf_with_ruby(output_path, options={})
      # puts "genrateing pdf ruby "
      start_time    = Time.now
      style_service = RLayout::StyleService.shared_style_service
      @pdf_doc  = HexaPDF::Document.new
      style_service.pdf_doc = @pdf_doc
      load_fonts(@pdf_doc)     
      # style_service.set_canvas_text_style(canvas, 'body')
      pages.each do |page|
        pdf_page    = @pdf_doc.pages.add([0, 0, @width, @height])
        canvas      = pdf_page.canvas
        page.draw_pdf(canvas)
      end
      @pdf_doc.write(output_path)
      ending_time = Time.now
      if options[:page_pdf]
        split_pdf(output_path)
      end
      puts "It took:#{ending_time - start_time}" if options[:time]
    end

    # split pdf_file_path file into single page pdf and move it to page folder
    def split_pdf(pdf_file_path)
      folder_path  = File.dirname(pdf_file_path)
      pdf_basename = File.basename(pdf_file_path)
      # split output_path pdf into 4 digit single page pdfs
      # 0001.pdf, 0002.pdf, 0003.pdf ...
      system("cd #{folder_path} && hexapdf split #{pdf_basename} --force")
      Dir.glob("#{folder_path}/*.pdf").each do |pdf|
        if pdf=~/(\d\d\d\d)\.pdf$/
          page_pdf_basename = File.basename(pdf)
          page_folder_name = $1
          page_folder_path = folder_path + "/#{page_folder_name}"
          FileUtils.mkdir_p(page_folder_path) unless File.exist?(page_folder_path)
          system("cd #{folder_path} && mv #{page_pdf_basename} #{page_folder_name}/page.pdf")
        end
      end
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