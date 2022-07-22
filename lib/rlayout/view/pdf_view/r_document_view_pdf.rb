module RLayout

  class RDocument
    attr_accessor :pdf_doc

    def save_pdf(output_path, options={})
      # puts "genrateing pdf ruby "
      @jpg = options[:jpg]
      start_time    = Time.now
      style_service = RLayout::StyleService.shared_style_service
      @pdf_doc  = HexaPDF::Document.new
      style_service.pdf_doc = @pdf_doc
      # style_service.set_canvas_text_style(canvas, 'body')
      @pages.each do |page|
        pdf_page    = @pdf_doc.pages.add([0, 0, @width, @height])
        canvas      = pdf_page.canvas
        page.draw_pdf(canvas, pdf_doc: @pdf_doc)
      end
      @pdf_doc.write(output_path)
      ending_time = Time.now
      if options[:page_pdf]
        RLayout::split_pdf(output_path)
      end

      puts "It took:#{ending_time - start_time}" if options[:time]
    end

    # using vips convert pdf 2 jpg
    # if enlarging ratio is given as options, it enlarges pdf canvas to the given ratio, 
    # then generates jpg, giving the hi-resolution result
    def convert_pdf2jpg(output_path, options={})
      @pdf_folder = File.dirname(output_path)
      if options[:ratio]
        ratio = options[:ratio] || 2.0
        enlarged_path = output_path.gsub(/.pdf$/, "_enlarged.pdf")
        target = HexaPDF::Document.new
        src =  HexaPDF::Document.open(output_path)
        src.pages.each do |page|
          form = target.import(page.to_form_xobject)
          width = form.box.width * ratio
          height = form.box.height * ratio
          canvas = target.pages.add([0, 0, width, height]).canvas
          canvas.xobject(form, at: [0, 0], width: width, height: height)
        end
        target.write(enlarged_path, optimize: true)
        @enlarged_pdf_base_name = File.basename(enlarged_path)
        @jpg_base_name = File.basename(output_path).gsub(/.pdf$/, ".jpg")
        commend  = "cd #{@pdf_folder} && vips copy #{@enlarged_pdf_base_name}[n=-1] #{@jpg_base_name}"
        # TODO use imagemagick
        system(commend)
        system("rm #{enlarged_path}")
      else
        @pdf_base_name = File.basename(output_path)
        @jpg_base_name = @pdf_base_name.gsub(/.pdf$/, ".jpg")
        commend  = "cd #{@pdf_folder} && vips copy #{@pdf_base_name}[n=-1] #{@jpg_base_name}"
        system(commend)
      end
    end
  
  end

end