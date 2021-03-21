

module RLayout
  class NewsHeadingMaker
    attr_accessor :output_path, :jpg, :heading
    def initialize(options={})
      @heading_path = options[:heading_path]
      unless File.directory?(@heading_path)
        puts "@heading_path:#{@heading_path} doen not exist!!!"
        return
      end
      @output_path  = options.fetch(:output_path, @heading_path + "/output.pdf")
      @layout_path  = Dir.glob("#{@heading_path}/*.{rb,script,pgscript}").first
      @layout_script= File.open(@layout_path, 'r'){|f| f.read}
      @heading      = eval(@layout_script)
      if @heading.is_a?(SyntaxError)
        puts "SyntaxError in #{@template_path} !!!!"
        return
      end
      if RUBY_ENGINE == "rubymotion"
        @heading.save_pdf(@output_path)
      end
      self
    end
  end

  # Heading for rest of pages
  class NewsHeading < Container
    attr_accessor :date, :page_number, :section_name, :publication_name, :bg_image
    def initialize(options={}, &block)
      super
      @bg_image         = image(optiuons) if options[:bground_image]
      @page_number      = text(optiuons[:page_number])
      @date             = text(optiuons[:date])
      @section_name     = text(optiuons[:section_name])
      @publication_name = text(optiuons[:section_name])
      self
    end
  end

end
