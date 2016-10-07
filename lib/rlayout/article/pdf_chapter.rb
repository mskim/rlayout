
module RLayout
  
  # PDFChapter
  # processes pdf files in project folder.
  # It takes care of multiple pdf files by merging and backup originals
  # default option is to merge pdf file and save it as outout.pdf, 
  # -merge=false prevents it from merging them
  # -jpg:false prevents it from creating jpg, them
  # -preview:false prevents it from creating preview folder
  # -doc_info=false prevents it from saving doc_info
  
  #TODO Split 
  # IF output.pdf exists, and options is to generate preview
  # check if they are upto date and don't redo it.
  class PDFChapter
    attr_accessor :project_path, :merge, :original_pdf_files
    attr_accessor :pdf_path, :pdf_doc, :page_count, :jpg, :preview
    
    def initialize(options={})
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
        @pdfdoc       = PDFDocument.alloc.initWithURL url
      end
      @jpg            = options.fetch(:jpg, true)
      @preview        = options.fetch(:preview, true)
      @doc_info       = options.fetch(:doc_info, true)
      unless RUBY_ENGINE == 'rubymotion'
        puts "in Ruby mode"
        return
      end
      @page_count     = @pdf_doc.pageCount
      save_jpg        if @jpg
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
        # next if path =~ /output.pdf/
        url = NSURL.fileURLWithPath path
        pdf_chapter = PDFDocument.alloc.initWithURL url
        pdf_chapter.pageCount.times do |i|
          page = pdf_chapter.pageAtIndex i
          pdf_data = page.dataRepresentation
          page=PDFDocument.alloc.initWithData(pdf_data).pageAtIndex(0)
          merged_pdf.insertPage(page, atIndex: merged_pdf.pageCount)
        end
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
    
    def save_jpg
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
          jpg_path  = @pdf_path.sub(".pdf", "_#{(i+1).to_s.rjust(3,'0')}.jpg")
        end
        imageData.writeToFile(jpg_path, atomically:false)
      end      
    end
  end
  

end