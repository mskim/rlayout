module RLayout
  #code
  class FontWidthExtractor
    attr_accessor :folder, :text_style_yml

    def initialize(folder, options={})
      @folder         = folder
      @text_style_yml = @folder + "/text_style.yml"
      unless File.exist?(@text_style_yml)
        puts "No text_style yaml found!!!"
      end

      yml = File.open(@text_style_yml, 'r'){|f| f.read}
      h = YAML::load(yml)
      h.each do |name, style|
        font_name = style['font']
        result = get_font_info_for_unicode_font(font_name)
        font_width_folder = "/Users/Shared/SoftwareLab/font_width"
        system("mkdir -p #{font_width_folder}") unless File.exist?(font_width_folder)
        font_width_file = font_width_folder + "/#{font_name}.rb"
        File.open(font_width_file, 'w'){|f| f.write result.to_s}
      end
      self
    end

    def get_font_info_for_unicode_font(font_name)
      font_object = NSFont.fontWithName(font_name, size:1000)
      unless font_object
        puts "#{font_name} not found!"
        return Hash.new
      end
      atts={}
      atts[NSFontAttributeName] = font_object
      covered = font_object.coveredCharacterSet
      number_of_glyphs = font_object.numberOfGlyphs

      @h = []

      # first do char under 200
      (0..255).to_a.each do |i|
        # puts i.chr
        char = i.chr
        att_string  = NSMutableAttributedString.alloc.initWithString(char, attributes:atts)
        w = att_string.size.width.round(2)
        @h << w
      end

      korean = []
      # do unicode over 200
      if number_of_glyphs > 200
        SAMPLE_KOREAN.each do |char|
          # puts i.chr
          att_string  = NSMutableAttributedString.alloc.initWithString(char, attributes:atts)
          korean    << att_string.size.width.round(2)
        end
      end
      # puts "font_object.numberOfGlyphs:#{font_object.numberOfGlyphs}"
      # puts "++++++++"
      # puts "@font_object.coveredCharacterSet:#{covered}"
      # puts "covered.class:#{covered.class}"
      font_info = {}
      font_info[:acender]     = font_object.ascender
      font_info[:descender]   = font_object.descender
      font_info[:leading]     = font_object.leading
      font_info[:korean_fixed_width]= korean.first
      font_info[:ascii_width] = @h
      font_info
    end
  end
end

SAMPLE_KOREAN = %w[가 까 깨 나 다 라 마 바 사 시]
