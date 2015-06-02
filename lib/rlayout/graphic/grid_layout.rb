

HEADING_COLUMNS_TABLE = {
  1 => 1,
  2 => 2,
  3 => 2,
  4 => 2,
  5 => 3,
  6 => 3,
  7 => 3
}

GRID_PATTERNS ={
  "1x1/1"=>[[0, 0, 1, 1]], 
  "1x2/2"=>[[0, 0, 2, 1], [0, 1, 2, 1]], 
  "2x2/3"=>[[0, 0, 2, 1], [2, 0, 1, 2], [0, 1, 2, 1]], 
  "2x2/4"=>[[0, 0, 1, 1], [1, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1]], 
  "3x3/2"=>[[0, 0, 2, 2], [2, 2, 1, 1]], 
  "3x3/3"=>[[0, 0, 1, 1], [1, 1, 1, 1], [2, 2, 1, 1]], 
  "3x3/5"=>[[0, 0, 3, 1], [0, 1, 3, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]], 
  "3x3/6"=>[[0, 0, 3, 1], [0, 1, 2, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]], 
  "3x3/7"=>[[0, 0, 3, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]], 
  "3x3/8"=>[[0, 0, 1, 1], [1, 0, 1, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 2, 1]], 
  "3x3/8_1"=>[[0, 0, 1, 1], [1, 0, 1, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 2, 1], [2, 2, 1, 1]], 
  "3x3/8_2"=>[[0, 0, 2, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]], 
  "3x3/9"=>[[0, 0, 1, 1], [1, 0, 1, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]], 
  # "4x7/2"=>[],
  # "4x7/3"=>[],
  # "4x7/4"=>[],
  # "4x7/5"=>[],
  # "4x7/6"=>[],
  # "4x7/7"=>[],
  "6x6/1"=>[[0, 0, 1, 1]], 
  "6x6/3"=>[[0, 0, 1, 1], [0, 0, 1, 1], [0, 0, 1, 1]], 
  "7x11/3"=>[[0, 0, 4, 6], [4, 0, 3, 6], [0, 6, 7, 5]], 
  "7x11/4"=>[[0, 0, 4, 5], [4, 0, 3, 5], [0, 5, 3, 6], [3, 5, 4, 6]], 
  "7x11/5"=>[[0, 0, 7, 3], [0, 3, 4, 3], [4, 3, 3, 4], [0, 6, 4, 5], [4, 7, 3, 4]], 
  "7x11/6"=>[[0, 0, 4, 3], [4, 0, 3, 4], [0, 3, 4, 3], [4, 4, 3, 3], [0, 6, 4, 5], [4, 7, 3, 4]], 
  "7x12/H/4"=>[[0, 0, 7, 1], [0, 1, 4, 4], [4, 1, 3, 4], [0, 5, 7, 2], [0, 7, 7, 5]], 
  "7x12/4"=>[[0, 1, 4, 4], [4, 1, 3, 4], [0, 5, 7, 2], [0, 7, 7, 5]], 
  "7x12/H/5"=>[[0, 0, 7, 1], [0, 1, 4, 3], [4, 1, 3, 4], [0, 4, 4, 5], [4, 5, 3, 4], [0, 9, 7, 3]], 
  "7x12/5"=>[[0, 0, 7, 3], [0, 3, 4, 3], [4, 3, 3, 4], [0, 6, 4, 5], [4, 7, 3, 4]], 
  "7x12/H/6"=>[[0, 0, 7, 1], [0, 1, 4, 2], [4, 1, 3, 4], [0, 3, 4, 2], [0, 5, 4, 2], [4, 5, 3, 2], [0, 7, 7, 5]], 
  "7x12/6"=>[[0, 1, 4, 2], [4, 1, 3, 4], [0, 3, 4, 2], [0, 5, 4, 2], [4, 5, 3, 2], [0, 7, 7, 5]], 
  "7x12/7"=>[[0, 0, 7, 1], [0, 1, 4, 2], [4, 1, 3, 4], [0, 3, 4, 2], [0, 5, 4, 2], [4, 5, 3, 2], [0, 7, 7, 5]]}
  
NEWS_PAPER_DEFAULTS = {
  name: "Ourtown News",
  period: "daily",
  paper_size: "A2"
}

NEW_SECTION_DEFAULTS = {
  :width        => 1190.55,
  :height       => 1683.78,
  :grid         => [7, 12],
  :lines_in_grid=> 10,
  :gutter       => 10,
  :left_margin  => 50,
  :top_margin   => 50,
  :right_margin => 50,
  :bottom_margin=> 50,
}

module RLayout
  class GridFrame
    attr_accessor :frame, :color, :tag, :kind, :grid_width, :grid_height
    attr_accessor :grid_column, :grid_row
    def initialize(frame, options={})
      @frame        = frame
      @color        = options.fetch(:color, 'white')
      @tag          = options[:tag] if options[:tag]
      @kind         = options[:kind] if options[:kind]
      @grid_column  = options[:columns]
      @grid_row     = options[:rows]
      @grid_width   = 100
      @grid_height  = 100
      self
    end
    
    def max_width_height_ratio
      #TODO ?? What is is??
      w = @frame[2]/@frame[3]
      h = @frame[2]/@frame[3]
      w >= h ? h : w
    end
    
    def x
      @frame[0]
    end
    
    def y
      @frame[1]
    end
    
    def width
      @frame[2]
    end
    
    def height
      @frame[3]
    end
    
    def area
      width*height
    end
    
    def to_svg
      puts "to_svg of GridFrame"
      puts "grid_column:#{grid_column}"
      puts "grid_row:#{grid_row}"
      puts "frame:#{frame}"
      s= "<rect x=\"#{frame[0]*100/grid_column}%\" y=\"#{frame[1]*100/grid_row}%\" width=\"#{frame[2]*100/grid_column}%\" height=\"#{frame[3]*100/grid_row}%\" stroke=\"red\" stroke-width=\"2\" fill=\"#{color}\" />\n"
      puts s
      s
    end
    
    def flip_vertically(row_number)
      original = @frame.dup
      @frame[1]= row_number - original[3]   
    end
    
    def flip_horizontally(column_number)
      original = @frame.dup
      @frame[0]= column_number - original[2]
    end
    
    def flip_both_way(width, height)
      flip_horizontally(width)
      flip_vertically(height)
    end
    
    def slit_frame(optionas={})
      
    end
  end
  
  class GridLayout
	  attr_accessor :grid_key, :frames, :column_number, :row_number, :patterns
	  def initialize(grid_key, options={})
	    @grid_key       = grid_key
	    @patterns       = options.fetch(:frames, GRID_PATTERNS[@grid_key])
  	  @grid_frames    = options[:grid_frames] if options[:grid_frames]
	    @columns        = grid_key.split("/")[0].split("x")[0].to_i
	    @rows           = grid_key.split("/")[0].split("x")[1].to_i
	    @frames         = @patterns.map{|p| GridFrame.new(p, columns: @columns, rows: @rows)}
	    self
	  end
    
    # genetate a grid_patter with given grid_base and number_of_frames
    # see if the generated pattern is present in the pool
    # if not, save the new 
    # grid_patterns.yml
    # strategy
    # 1. make 2, 3, 4, chunks
    # 2. 
    def self.new_with_grid_base_and_number(grid_base, number_of_frames)
      [2..4].to_a.each do i
        
      end
    end
    
    def expand_grid_width_to(number)
      
    end
    
    # adds one more frame to exiisting grid patteren
    # by selcting the largest area frame and spiting it.
    def add_frame
      frames_by_area    = frames.dup.sort{|x,y| x.area <=> y.area}
      frames_by_area.first.spit
      @number_of_frames +=1
      # sort them by area
      
    end
    
    def expand_grid_height_to(number)
      
    end
    
    def divide_cell_at(cell_index)
      
    end
    
    def self.new_2x2
    
    end
    
    def has_heading?
      grid_key.split("/")[1]=~/^H/ ? true : false
    end
    
    def self.find_all
      grid_object_array = []
      GRID_PATTERNS.each do |item|
        grid_object_array << GridLayout.new(item[0], :patterns=>item[1])
      end
      grid_object_array
    end
    
    def self.find_with_grid_key(grid_key)
      GridLayout.new(grid_key, :patterns=>GRID_PATTERNS[grid_key])
    end
    
    # find all possible GridLayout with given number of grid_frames
    def self.find_with_number_of_frames(number_of_frames)
      candidates = []
      GRID_PATTERNS.each do |item|
        if item[0]=~/\/#{number_of_frames.to_s}(_\d)?$/
           candidates << item
        end     
      end
      candidates.map{|f| GridLayout.new(f[0], :patterns=>f[1])}
    end
    
    
    def self.find_with_grid_base_and_number(grid_base, number_of_frames)
      candidates = []
      GRID_PATTERNS.each do |item|
        if item[0]=~/^#{grid_base}(H)?\/#{number_of_frames.to_s}(_\d)?$/
           candidates << item
        end     
      end
      candidates.map{|f| GridLayout.new(f[0], :patterns=>f[1])}
    end
    
    # sort given grid_layout_list by its total area
    def self.sort_by_area(grid_layout_list, options={})
      grid_layout_list.sort!{|x,y| x.total_area <=> y.total_area} 
    end
    
    def self.expand_grid_for_size(width, height, grid_key, options={})
      #TODO margin, gutter, v_gutter
      expanded = GRID_PATTERNS[grid_key].map do |cell|
        [cell[0]*@grid_width, cell[1]*@grid_height, cell[2]*@grid_width, cell[3]*@grid_height]
      end
      expanded
    end
    
    def total_area
      total_area = 0
      @frames.each do |item|
        total_area += item.frame[2]*item.frame[3]
      end
      total_area
    end
    
    # check if two arrays of frames are virtually equal,  
    def self.has_equal_frames?(first, second)
      first.each do |frame|
        return false unless second.include?(frame)
      end
      true
    end
    
    def to_svg
      svg_sting =""
      frames.each do |frame|
        svg_sting += frame.to_svg
      end
      style ="style=\"fill:white;stroke-color:red;stroke-width:3\""
      
      s=<<EOF
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<rect x="0%" y="0%" width="100%" height="100%" #{style} />
#{svg_sting}
</svg>
EOF
      s
    end    
    
    def save_svg(folder_path)
      escaped = grid_key.gsub("/","_")
      path = folder_path + "/#{escaped}.svg"
      File.open(path, 'w'){|f| f.write to_svg}
    end
    
    def save_yaml(folder_path)
      escaped = grid_key.gsub("/","_")
      path = folder_path + "/#{escaped}.yml"
      File.open(path, 'w'){|f| f.write @patterns.to_yaml}
    end
    
    def save_html(path)
      
    end
        
    # tells whether it has hole, doen not cover the eintire area 
    def has_hole?
      
    end
    
    def frame_rects
      rects = []
      @frames.each do |f|
        rects << f.frame
      end
      rects
    end
    # tells whether it has frame that has a width to height ratio greated than 2
    # not good for image  
    def has_too_distored_frame?
      @frames.each do |f|
        return true if f.max_width_height_ratio > 2
      end
      false
    end
    
    def sort_frames_by_y_and_x
      @frames.sort_by! {|f| [f.frame[1], f.frame[0]] }
      @patterns = @frames.map{|f| f.frame}
      # # in order to sort by y and x
      # # first sort by x
      # # then the final sort should be by y
      # @frames.sort!{|x,y| x.frame[0] <=> y.frame[0]}      
      # @frames.sort!{|x,y| x.frame[1] <=> y.frame[1]}
    end
    
    def flip_vertically
      height = @row_number
      if has_heading?
        heading     = copyed.shift 
        height -= 1
      end
      @frames.map do |frame|
        frame.flip_vertically(height)
      end
      @frames.unshift(heading) if has_heading?
      @patterns = @frames.map{|f| f.frame}
    end
    
    def flip_horizontally 
      @frames.map do |frame|
        frame.flip_horizontally(@column_number)
      end
      @patterns = @frames.map{|f| f.frame}
    end
    
    def flip_both_way
      flip_horizontally
      flip_vertically
    end
    
    # create a variation from give pattern
    # first sort frame by position
    # flip vertically, horixontally, and both way
    # sort each variables by position
    # if they are eventually equl pattern, rejuct it from the list
    def self.create_variation_from(grid_key)
      variations = []
      if GRID_PATTERNS[grid_key]
        puts "grid_key:#{grid_key}"
        puts "#{GRID_PATTERNS[grid_key]}"
        grid_layout = GridLayout.new(grid_key)
        a = grid_layout.flip_horizontally
        puts "flip_horizontally"
        puts a.to_s
        variations << a
        grid_layout = GridLayout.new(grid_key)
        b = grid_layout.dup.flip_vertically
        puts "flip_vertically"
        puts b.to_s
        variations << b
        grid_layout = GridLayout.new(grid_key)
        c = grid_layout.dup.flip_both_way
        puts "flip_vertically"
        puts c.to_s
        variations << c
      else
        puts "grid_key:#{grid_key} has no patterns!!!"
      end
      variations
    end
  end

end

__END__
puts GridLayout.expand_grid_for_size(600,800, "3x3/2")
