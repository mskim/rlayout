module RLayout

  class CodeMusic < Document
    attr_accessor :project_path, :music_hash, :piano_keys, :piano_codes_path
    
    def initialize(options={}, &block)
      @project_path = options[:project_path]
      yml_path      = Dir.glob("#{@project_path}/*.yml").first
      @music_hash   = YAML::load(File.open(yml_path, 'r'){|f| f.read}) 
      save_piano_keys_scripts
      generate_piano_code
      layout_pages
      self
    end
    
    def layout_pages
      measues_count = @music_hash[:measures].length
      
      
      
    end
    
    def save_piano_keys_scripts
      @piano_keys = []
      # puts "@music_hash[:measures].length:#{@music_hash[:measures].length}"
      @music_hash[:measures].each do |m|
        script_path = @project_path + "/script/#{m[:number]}.rb"
        outputs_path = @project_path + "/piano_cord/#{m[:number]}.pdf"
        puts "m:#{m}"
        puts "m[:lyric]:#{m[:lyric]}"
        piano_code_script = <<-EOF
  @output_path = '#{outputs_path}'
  RLayout::PianoFinger.new(nil, number: '#{m[:number]}', cord: '#{m[:cord]}', lyric: '#{m[:lyric]}', project_path: '#{@project_path}')
EOF
        File.open(script_path, 'w'){|f| f.write piano_code_script}
      end
    end
    
    def generate_piano_code
      script_dir = "/Users/mskim/Development/music/songs/iu/script"
      Dir.glob("#{script_dir}/*.rb").each do |script|
        system "/Applications/rjob.app/Contents/MacOS/rjob #{script}"
      end
    end
    # 
  end
  
  # we have cord_layout and sheet_layout
  # 
  
  class CodeMusicPage < Page
    attr_accessor :heading, :code_layout, :sheet_image, :sheet_layout, :cord_layout
    def initialize(parent_graphic, options={})
      super
      @sheet_image = options[:sheet_image]
      @grid_images = options[:grid_images]
      if @sheet_image
        @cord_layout = GricBox.new(self, grid_images: @grid_images, grid_base: [3, 4], layout_length: 2)
        @sheet_layout = Image.new(self, image_path: @sheet_image)
      else
        @cord_layout = GricBox.new(self, grid_images: @grid_images, grid_base: [3, 8], layout_length: 2)
      end
      relayout!
      self
    end
  end
  
  class PianoFinger < Container
    attr_accessor :number, :project_path, :piano_codes_path, :image_path, :code, :lyric, :code_image, :lyric_layout, :output_path
    def initialize(parent_graphic, options={})
      options[:width] = 300 unless options[:width]
      super
      puts "options:#{options}"
      @project_path     = options[:project_path]
      @piano_codes_path = "/Users/Shared/piano_cord"
      @number           = options[:number] #|| options['number']
      @code             = options[:code] #|| options['code']
      @lyric            = options[:lyric] #|| options['lyric']
      @image_path       = @piano_codes_path + "/#{@code}.jpg"
      unless File.exist?(@image_path)
        @image_path = @piano_codes_path + "/default.jpg"
      end
      puts "@lyric:#{@lyric}"
      puts "@image_path:#{@image_path}"
      @lyric_layout     = Text.new(self, text_string: @lyric, text_size: 12)
      @code_image       = Image.new(self, image_path: @image_path, layout_length: 4)
      relayout!
      self
    end
    
  end
end