module RLayout
  class NewsHeadingMaker
    attr_accessor :output_path, :jpg, :heading
    def initialize(options={})
      @heading_path = options[:heading_path]
      @output_path  = options.fetch(:output_path, @heading_path + "/output.pdf")
      @layout_path  = Dir.glob("#{@heading_path}/*.{rb,script,pgscript}").first
      @layout_script= File.open(@layout_path, 'r'){|f| f.read}
      @heading      = eval(@layout_script)
      puts "@heading.class:#{@heading.class}"
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

  class NewsHeading < Container
    attr_accessor :date, :news_logo, :left_ad, :right_ad, :info_box
    def initialize(options={}, &block)
      @grid_base = options.fetch(:grid_base, [7,1])
      super
      @left_ad = Image.new(:parent=>self, parent_grid: true, grid_frame:[0,1,1,1])
      @right_ad = Image.new(:parent=>self, parent_grid: true, grid_frame:[-1,0,1,0.8])
      @data = Image.new(:parent=>self, parent_grid: true, grid_frame:[-1,0.8,1,0.1])
      @news_logo = Image.new(:parent=>self, parent_grid: true, grid_frame:[2,0,4,1])
    end
  end
end
