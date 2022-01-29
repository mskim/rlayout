module RLayout

  class YbSection
    attr_reader :section_path
    attr_reader :pages_path, :starting_page_number
    attr_reader :section_pdf_path
    def initialize(options={})
      @section_path = options[:section_path]
      unless File.exists?(@section_path)
        puts "Section #{@section_path} not found!!!"
      end
      @starting_page_number = options[:starting_page_number] || 1
      @section_name_array  = File.basename(@section_path).split("_").first
      @section_kind = @section_name_array[0]
      @section_order = @section_name_array[1]
      process_pages
      combind_section_pages
      self
    end

    def process_pages
      @pages_path = Dir.glob("#{@section_path}/**").select{|f| File.directory?(f)}
      @pages_path.each_with_index do |page_path, i|
        @page_number = @starting_page_number + i
        pdf_path = page_path + "/output.pdf"
        RLayout::YbPage.new(page_path: page_path,  page_number: @page_number).save_pdf(pdf_path)
      end
    end

    def combind_section_pages
      @section_pdf_path = @section_path + "/section.pdf"
      target = HexaPDF::Document.new
      @pages_path.each do |page_path|
        pdf = HexaPDF::Document.open(page_path + "/output.pdf")
        pdf.pages.each {|page| target.pages << target.import(page)}
      end
      target.write(@section_pdf_path, optimize: true)
    end
  end


end