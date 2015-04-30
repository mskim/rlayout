

HEADING_COLUMNS_TABLE = {
  1 => 1,
  2 => 2,
  3 => 2,
  4 => 2,
  5 => 3,
  6 => 3,
  7 => 3
}

GRID_PATTERNS = {
 "1x1/1"=>[[0,0,1,1]],
 "1x2/2"=>[[0,0,2,1],[0,1,2,1]],
 "2x2/3"=>[[0,0,2,1],[0,1,2,1], [2,0,1,2]],
 "2x2/4"=>[[0,0,1,1],[1,0,1,1], [0,1,1,1], [1,1,1,1]],
 "3x3/2"=>[[0,0,2,2],[2,2,1,1]],
 "3x3/3"=>[[0,0,1,1],[1,1,1,1],[2,2,1,1]],
 "3x3/5"=>[[0, 0, 3, 1], [0, 1, 3, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]],
 "3x3/6"=>
  [[0, 0, 3, 1],
   [0, 1, 2, 1],
   [2, 1, 1, 1],
   [0, 2, 1, 1],
   [1, 2, 1, 1],
   [2, 2, 1, 1]],
 "3x3/7"=>
  [[0, 0, 3, 1],
   [0, 1, 1, 1],
   [1, 1, 1, 1],
   [2, 1, 1, 1],
   [0, 2, 1, 1],
   [1, 2, 1, 1],
   [2, 2, 1, 1]],
 "3x3/8"=>
  [[0, 0, 1, 1],
   [1, 0, 1, 1],
   [2, 0, 1, 1],
   [0, 1, 1, 1],
   [1, 1, 1, 1],
   [2, 1, 1, 1],
   [0, 2, 1, 1],
   [1, 2, 2, 1]],
 "3x3/8_1"=>
  [[2, 0, 1, 1],
   [1, 0, 1, 1],
   [0, 0, 1, 1],
   [2, 1, 1, 1],
   [1, 1, 1, 1],
   [0, 1, 1, 1],
   [2, 2, 1, 1],
   [0, 2, 2, 1]],
 "3x3/8_2"=>
  [[2, 2, 1, 1],
   [1, 2, 1, 1],
   [0, 2, 1, 1],
   [2, 1, 1, 1],
   [1, 1, 1, 1],
   [0, 1, 1, 1],
   [2, 0, 1, 1],
   [0, 0, 2, 1]],
 "3x3/9"=>
  [[0, 0, 1, 1],
   [1, 0, 1, 1],
   [2, 0, 1, 1],
   [0, 1, 1, 1],
   [1, 1, 1, 1],
   [2, 1, 1, 1],
   [0, 2, 1, 1],
   [1, 2, 1, 1],
   [2, 2, 1, 1]],
 "6x6/1"=>[[0, 0, 1, 1]],
 "6x6/3"=>[[0, 0, 1, 1], [0, 0, 1, 1], [0, 0, 1, 1]],
 "7x11/3"=>[[0, 6, 7, 5], [0, 0, 4, 6], [4, 0, 3, 6]],
 "7x11/4"=>[[0, 5, 3, 6], [0, 0, 4, 5], [4, 0, 3, 5], [3, 5, 4, 6]],
 "7x11/5"=>
  [[4, 3, 3, 4], [0, 3, 4, 3], [0, 6, 4, 5], [4, 7, 3, 4], [0, 0, 7, 3]],
 "7x11/6"=>
  [[4, 4, 3, 3],
   [0, 3, 4, 3],
   [0, 6, 4, 5],
   [4, 7, 3, 4],
   [0, 0, 4, 3],
   [4, 0, 3, 4]],
 "7x12/H/4"=>
   [[0, 0, 7, 1], [0, 7, 7, 5], [4, 1, 3, 4], [0, 1, 4, 4], [0, 5, 7, 2]],
 "7x12/4"=>
   [[0, 7, 7, 5], [4, 1, 3, 4], [0, 1, 4, 4], [0, 5, 7, 2]],
 "7x12/H/5"=>
   [[0, 0, 7, 1], [4, 1, 3, 4], [0, 1, 4, 3], [0, 4, 4, 5], [4, 5, 3, 4], [0, 9, 7, 3]],
 "7x12/5"=>
   [[4, 3, 3, 4], [0, 3, 4, 3], [0, 6, 4, 5], [4, 7, 3, 4], [0, 0, 7, 3]],
 "7x12/H/6"=>
   [[0, 0, 7, 1], [0, 7, 7, 5], [4, 1, 3, 4], [0, 1, 4, 2], [0, 3, 4, 2], [0, 5, 4, 2],[4, 5, 3, 2]],
 "7x12/6"=>
   [[0, 7, 7, 5], [4, 1, 3, 4], [0, 1, 4, 2], [0, 3, 4, 2], [0, 5, 4, 2],[4, 5, 3, 2]],

#TODO
 "7x12/7"=>
   [[0, 0, 7, 1], [0, 7, 7, 5], [4, 1, 3, 4], [0, 1, 4, 2], [0, 3, 4, 2], [0, 5, 4, 2],[4, 5, 3, 2]]}

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
    attr_accessor :frame, :color, :tag, :kind
    
    def initialize(frame, options={})
      @frame = frame
      @color = options.fetch(:color, 'white')
      @tag   = options[:tag] if options[:tag]
      @kind  = options[:kind] if options[:kind]
      self
    end
    
    def max_width_height_ratio
      w = width/height
      h = width/height
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
    
    def to_svg
      "<rect x=\"#{frame[0]*grid_width}\" y=\"#{frame[1]*grid_height}\" width=\"#{frame[2]*grid_width}\" height=\"#{frame[3]*grid_height}\" stroke=\"red\" stroke-width=\"2\" fill=\"#{color}\" />\n"
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
  end
  
  class GridLayout
	  attr_accessor :grid_key, :frames, :column_number, :row_number
	  def initialize(grid_key, options={})
	    @grid_key       = grid_key
	    @patterns       = options.fetch(:frames, GRID_PATTERNS[@grid_key])
	    @frames         = @patterns.map{|p| GridFrame.new(p)}
  	  @grid_frames    = options[:grid_frames] if options[:grid_frames]
	    @column_number  = grid_key.split("/")[0].split("x")[0].to_i
	    @row_number     = grid_key.split("/")[0].split("x")[1].to_i
	    self
	  end
    
    def has_heading?
      grid_key.split("/")[1]=~/^H/ ? true : false
    end
    
    
    # find all possible GridLayout with given number of grid_frames
    def self.find_grid_layout_with(number_of_grid_frames)
      candidates = []
      GRID_PATTERNS.each do |item|
        if item[0]=~/\/#{number_of_grid_frames.to_s}(_\d)?$/
           candidates << item
        end     
      end
      candidates.map{|f| GridLayout.new(f[0], :patterns=>f[1])}
    end
    
    # sort given grid_layout_list by its total area
    def self.sort_by_area(grid_layout_list, options={})
      grid_layout_list.sort!{|x,y| x.total_area <=> y.total_area} 
    end
    
    def self.expand_grid_for_size(width, heigth, grid_key, options={})
      #TODO margin, gutter, v_gutter
      expanded = GRID_PATTERNS[grid_key].map do |cell|
        [cell[0]*grid_width, cell[1]*grid_height, cell[2]*grid_width, cell[3]*grid_height]
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
      s=<<EOF
<svg width="#{width}" height="#{height}">
<rect x="10" y="10" width="80%" height="90%" stroke="black" stroke-width="1" fill="white" />
#{svg_sting}
</svg>
EOF
      s
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
      @frames.sort!{|x,y| y.frame[1] <=> x.frame[1]}
      @frames.sort!{|x,y| x.frame[0] <=> y.frame[0] }
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
      heading = @frames.unshift(heading) if has_heading?
    end
    
    def flip_horizontally 
      @frames.map do |frame|
        frame.flip_horizontally(@column_number)
      end
    end
    
    def flip_both_way
      flip_hozinotally
      flip_vertically
    end
  end

end

__END__
puts GridLayout.expand_grid_for_size(600,800, "3x3/2")
