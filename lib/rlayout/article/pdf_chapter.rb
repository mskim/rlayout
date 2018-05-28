
module RLayout


  class Eps2jpg
    attr_accessor :eps_path, :pdf_doc, :page_count, :jpg, :preview

    def initialize(options={})
      @eps_path = option[:path]
      @jpg  = true
      url           = NSURL.fileURLWithPath @eps_path
      @pdf_doc      = PDFDocument.alloc.initWithURL url
      self
    end

    def save_image
      page        = @pdf_doc.pageAtIndex i
      pdfdata     = page.dataRepresentation
      image       = NSImage.alloc.initWithData pdfdata
      imageData   = image.TIFFRepresentation
      imageRep    = NSBitmapImageRep.imageRepWithData(imageData)
      imageProps  = {NSImageCompressionFactor=> 1.0}
      imageData   = imageRep.representationUsingType(NSJPEGFileType, properties:imageProps)
      jpg_path  = @pdf_path.sub(".eps", ".jpg")
      imageData.writeToFile(jpg_path, atomically:false)
    end

  end

  # PDFChapter
  # processes pdf files in project folder to chapter format.
  # It takes care of multiple PDF files by merging and backup originals
  # default is to merge pdf file and save it as single file called outout.pdf,
  #              create images in preview folder with page_001.jpg, page_002.jpg ...
  #              and create doc_info file with page_count, and other PDF informations
  # -jpg:true    generate jpg of first page only
  #              no preview folder nor doc_info is saved in this mode
  #              images are save with same name as pdf with .jpg extension

  # pdf_chapter split path/to/pdf/file
  #             split PDF files into single page PDF's in pdf_name_single_page
  #

  class PDFChapter
    attr_accessor :project_path, :merge, :original_pdf_files
    attr_accessor :pdf_path, :pdf_doc, :page_count, :jpg, :preview

    def initialize(options={})
      if options[:jpg]
        @jpg            = true
        @preview        = false
        @doc_info       = false
      else
        @jpg            = false
        @preview        = options.fetch(:preview, true)
        @doc_info       = options.fetch(:doc_info, true)
      end
      if options[:project_path]
        @project_path = options[:project_path]
        @original_pdf_files = Dir.glob("#{@project_path}/*.pdf")
        unless @original_pdf_files.length > 0
          puts "No pdf files in #{@project_path}!!!"
          return
        end
        options.delete(:project_path)
        @pdf_path = project_path + "/output.pdf"
        @pdf_doc  = merge_pdf_files
      elsif options[:pdf_path]
        @pdf_path     = options[:pdf_path]
        @project_path = File.dirname(@pdf_path)
        url           = NSURL.fileURLWithPath @pdf_path
        @pdf_doc      = PDFDocument.alloc.initWithURL url
      end
      unless RUBY_ENGINE == 'rubymotion'
        puts "in Ruby mode"
        return
      end
      @page_count     = @pdf_doc.pageCount
      save_image        if @jpg || @preview
      save_doc_info   if @doc_info
      self

    end

    # when output.pdf file is present, it is still merges with rest of pdf files
    # files are merged as file order, so name files as desired merge order
    def merge_pdf_files
      pdf_backup = @project_path + "/pdf_backup"
      system("mkdir -p #{pdf_backup}") unless File.directory?(pdf_backup)
      unless RUBY_ENGINE == 'rubymotion'
        puts "in Ruby mode"
        return
      end

      merged_pdf = PDFDocument.new
      @original_pdf_files.each do |path|
        url = NSURL.fileURLWithPath path
        pdf_chapter = PDFDocument.alloc.initWithURL url
        pdf_chapter.pageCount.times do |i|
          page = pdf_chapter.pageAtIndex i
          pdf_data = page.dataRepresentation
          page=PDFDocument.alloc.initWithData(pdf_data).pageAtIndex(0)
          merged_pdf.insertPage(page, atIndex: merged_pdf.pageCount)
        end
        # output.pdf is backed up overiding existing output.pdf backed up
        # backup output.pdf is always the previous version
        system("mv #{path} #{pdf_backup}/")
      end
      merged_pdf.writeToFile(@pdf_path)
      merged_pdf
    end

    def save_doc_info
      info_path = File.dirname(@pdf_path) + "/doc_info.yml"
      h         = {page_count: @page_count}
      File.open(info_path, 'w'){|f| f.write h.to_yaml}
    end

    def save_image
      if @preview
        @preview_path = File.dirname(@pdf_path) + "/preview"
        if File.directory?(@preview_path)
          # if we have old version, clear the folder
          # don't went any left over page that is not over written
          system("rm -r #{@preview_path}")
        end
        #generate new preview folder
        system("mkdir -p #{@preview_path}")
      end
      @page_count = 1 if @jpg
      @page_count.times do |i|
        page        = @pdf_doc.pageAtIndex i
        pdfdata     = page.dataRepresentation
        image       = NSImage.alloc.initWithData pdfdata
        imageData   = image.TIFFRepresentation
        imageRep    = NSBitmapImageRep.imageRepWithData(imageData)
        imageProps  = {NSImageCompressionFactor=> 1.0}
        imageData   = imageRep.representationUsingType(NSJPEGFileType, properties:imageProps)
        if @preview
          jpg_path  = @preview_path + "/page_#{(i+1).to_s.rjust(3,'0')}.jpg"
        else
          jpg_path  = @pdf_path.sub(".pdf", ".jpg")
        end
        imageData.writeToFile(jpg_path, atomically:false)
      end
    end

    def self.jpg_for_folder(folder)
      Dir.glob("#{folder}/*.pdf").each do |pdf|
        PDFChapter.new(pdf_path: pdf, jpg: true)
      end
    end

    def self.split_pdf(pdf_path)
      project_path = File.dirname(pdf_path)
      base_name    = File.basename(pdf_path,".pdf")
      url           = NSURL.fileURLWithPath pdf_path
      pdf_doc      = PDFDocument.alloc.initWithURL url
      if pdf_doc.pageCount == 1
        puts "single page pdf..."
        return
      end
      single_page_folder = project_path + "/#{base_name}_single_page"
      system("mkdir -p #{single_page_folder}") unless File.directory?(single_page_folder)
      pdf_doc.pageCount.times do |i|
        page = pdf_doc.pageAtIndex i
        single_page_pdf = PDFDocument.new
        single_page_pdf.insertPage(page, atIndex: 0)
        output_path = single_page_folder + "/page_#{(i+1).to_s.rjust(3,'0')}.pdf"
        single_page_pdf.writeToFile(output_path)
      end
    end
  end


end
