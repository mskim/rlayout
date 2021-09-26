
module RLayout
  class Graphic
    attr_accessor :flipped 

    def save_pdf_with_ruby(output_path, options={})
      # puts "genrateing pdf ruby "
      start_time    = Time.now
      style_service = RLayout::StyleService.shared_style_service
      unless @parent
        @pdf_doc  = HexaPDF::Document.new
        page      = @pdf_doc.pages.add([@x, @y, @width, @height])
        canvas    = page.canvas
      else
        @pdf_doc  = @parent.pdf_doc
        page          = @pdf_doc.pages.add([0, 0, @width, @height])
        canvas        = page.canvas     
      end
      style_service.pdf_doc = @pdf_doc
      # load_fonts(@pdf_doc)
      # style_service.set_canvas_text_style(canvas, 'body')
      draw_pdf(canvas)
      @pdf_doc.write(output_path)
      if options[:jpg]
        convert_pdf2jpg(output_path)
      end
      ending_time = Time.now
      # puts "It took:#{ending_time - start_time}" if options[:time]
    end

    # read fonts from disk
    def load_fonts(pdf_doc)
      font_foleder = "/Users/Shared/SoftwareLab/font_width"
      Dir.glob("#{font_foleder}/*.ttf").each do |font_file|
        pdf_doc.fonts.add(font_file)
      end
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
          single_page_pdf_path = folder_path + "/#{page_folder_name}/page.pdf"
          convert_pdf2jpg(single_page_pdf_path)
        end
      end
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
        system(commend)
        system("rm #{enlarged_path}")
      else
        @pdf_base_name = File.basename(output_path)
        @jpg_base_name = @pdf_base_name.gsub(/.pdf$/, ".jpg")
        commend  = "cd #{@pdf_folder} && vips copy #{@pdf_base_name}[n=-1] #{@jpg_base_name}"
        system(commend)
      end
    end
  
    def flipped_origin
      if @parent && @parent.class != RDocument
        p_origin = @parent.flipped_origin
        [p_origin[0] + @x, p_origin[1] - @y]
      else
        [@x, @height - @y]
      end
    end

    def draw_pdf(canvas)
      @pdf_doc = parent.pdf_doc if parent
      @flipped = flipped_origin
      draw_fill(canvas)
      draw_text(canvas)  if @has_text
      draw_stroke(canvas)

      if @rotate_content
        canvas.save_graphics_state
        canvas.translate(@x, @height).rotate(@rotate_content)
        # rotating image content 
        # 1. translate origin to top left translate(@x, @height)
        # 2. change the rect to rotating rect width: @height, height: @width
        canvas.image(@image_path, at: [0,0], width: @height, height: @width)
        # canvas.fill_color('0000ff').stroke_color('ffffff').line_width(2).rectangle(0, 0, @height, @width).fill_stroke
        canvas.restore_graphics_state
      else
        draw_image(canvas) if (@image_path || @local_image)
      end
    end

    def draw_fixtures(fixtures)
      fixtures.each do |child|
        draw_graphic_in_nsview(child)
      end
    end

    def draw_graphics(graphics)
      graphics.each do |child|
        child.to_pdf(canvas)
      end
    end

    def draw_floats(floats)
      floats.each do |child|
        child.to_pdf(canvas)
      end
    end


  end

end
