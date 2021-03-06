
# Grid patterns
# We need grid pattern for each grid_base, for design layout base.
# There could be lots of them, too many to do it manyally.
# We need to generate patterns using algorithm.
# Final goal is to create set of(couple of hundred) GridPatterns
# that covers most of possible layout patterns

# GridLayout
# given grid_base and number of cells, it should generate a pattern.
# GridLayout is used to generate a pattern by spliting root GridLayout into nested GridLayouts,
# and generate new patterns.
# Once pattern is created, check with existung GridPattern,
# If it already exists, then try an other route untile we run out of possbile patterns.

# GridPatternManager
# GridPatternManager is used to find, retreve, and save new patterns.
# Alos look for ad matching block and heading matching block and extract newspaper layout with ad and heading.

module RLayout

  class GridLayout
	  attr_accessor :grid_base, :x, :y, :columns, :rows, :type #article, ad, heading
	  attr_accessor :children, :patterns, :can_split
    attr_accessor :heading, :ad
	  def initialize(grid_base, options={})
	    @x              = options[:x] || 0
	    @y              = options[:y] || 0
      @grid_base      = grid_base
      if @grid_base.class == String
        @columns      = @grid_base.split("x")[0].to_i
	      @rows         = @grid_base.split("x")[1].to_i
      else
        @columns      = @grid_base[0].to_i
        @rows         = @grid_base[1].to_i
      end
      @type           = options[:type] || "article"
	    @children       = []

	    self
	  end

    def grid_layout_with_cell_count(cell_count)
      choices = []
      GRID_PATTERNS.each do |grid_pattern|
        choices << grid_pattern if grid_pattern.key =~/$\/#{cell_count}/
      end
      choices
    end

    # return grid_layout with given cell count
    def self.grid_layout_with_cell_count(cell_count)
      choices = []
      GRID_PATTERNS.each do |grid_pattern|
        choices << grid_pattern if grid_pattern.key =~/$\/#{cell_count}/
      end
      choices
    end

    # return grid_rects array, derived from chidren tree
    def grid_rects
      grid_rects = []
      if @children.length == 0
        grid_rects += grid_rect
      else
        @children.each do |child|
          grid_rects += child.grid_rects
        end
      end
      grid_rects.flatten!
      grouped_rects = grid_rects.each_slice(4).map{|x| x}
      grouped_rects.sort_by! {|f| [f[1], f[0]] }
      grouped_rects
    end

    def grid_rect
      [@x,@y, @columns, @rows]
    end

    def frame_count
      if @children.length == 0
        return 1
      else
        count = 0
        @children.each do |child|
          count += child.frame_count
        end
      end
      count
    end

    def grid_key
      "#{@grid_base}/#{frame_count}"
    end

    def add_heading
      puts __method__
      heading_size = [@columns, 1] #"#{@width}x1"
      @heading  =  GridLayout.new(heading_size, x:0, y:0, type: "heading")
      @children << @heading
      @y        = 1
      @rows     -= 1
      @heading
    end

    # add child GridLayout
    def add_ad(ad_rect)
      puts __method__
      ad_size = [ad_rect[2], ad_rect[3]]
      @ad = GridLayout.new(ad_size, x:ad_rect[0], y:ad_rect[1], type: "ad")
      if ad_rect[2] == @width
        # full width ad
        # top_side
        top =  GridLayout.new([ad_rect[2],ad_rect[3]], x:ad_rect[0], y:@y, type: "article")
        @children << top
        #
        @children << @ad
      else
        # add , ad, right_side, top_side
        # top_box
        # right_box
        top =  GridLayout.new(grid_base, type: "article")
        @children << top
        @children << @ad
      end
      ad
    end

    # genetate a GridLayout with given grid_base and number_of_frames
    def self.new_with_grid_base_and_number(grid_base, number_of_frames,options={})
      puts __method__
      @number_of_frames = number_of_frames
      gl = GridLayout.new(grid_base, x:0, y:0)
      if options[:heading]
        #add heading GridLayout
        gl.add_heading
      end
      if options[:ad]
        # ad grid rect is passed in Array
        # predefined ad space
        gl.add_ad(options[:ad])
        if options[:ad][2] == @columns
          # full width ad
          # add , ad, top_side
          split_count = @number_of_frames
        else
          # add , ad, right_side, top_side
          split_count = @number_of_frames - 2
        end
      end

      split_count = @number_of_frames - 1
      split_count.times do
        gl.split_grid
      end
      gl
    end

    # genetate a GridLayout with given grid_key
    def self.new_with_grid_key(grid_key, options={})
      input_array       = grid_key.split("/")
      grid_base         = input_array[0]
      number_of_frames  = input_array[1].to_i
      gl = GridLayout.new(grid_base, x:0, y:0)
      split_count = number_of_frames - 1
      if options[:heading]
        #add heading GridLayout
        gl.add_heading
        @y = 1
        split_count = number_of_frames - 1
      end

      if options[:ad]
        # ad grid rect is passed in Array
        # predefined ad space
        gl.add_ad(options[:ad])
        if options[:ad][2] == @columns
          # full width ad
          # add , ad, top_side
          @rows -= options[:ad][3]
        else
          # add , ad, right_side, top_side
          split_count = number_of_frames - 2
        end
      end
      split_count.times do
        gl.split_grid
      end
      gl
    end

    def children_count
      count = 0
      @children.each do |child|
        if child.children.length > 0
          count += child.children_count
        else
          count += 1
        end
      end
    end

    def can_split?
      return false if @type == 'ad' || @type == 'heading'
      @can_split = false
      if @children.length < 2 && @columns*@rows > 1
        @can_split =  true
      elsif @children[0].can_split?
        @can_split =  true
      elsif @children[1].can_split?
        @can_split =  true
      end
      @can_split
    end

    # given cell number, calculate needed rows and columns
    def calculate_columns_and_rows_for(number, options={})
      int_value=Math.sqrt(number).to_i

      if Math.sqrt(number) > Math.sqrt(number).to_i
        if (int_value+1)*(int_value) >=  number
          @columns  = int_value+1
          @rows     = int_value
        else
          @columns  = int_value+1
          @rows     = int_value+1
        end
      elsif Math.sqrt(number) == Math.sqrt(number).to_i
        @columns  = int_value
        @rows     = int_value
      end
    end

    def pattern
      {"#{grid_key}" => grid_rects}
    end

    # split grid into two
    def split_grid
      # puts __method__
      return false unless can_split?
      if @children.length < 2
        if @columns >= @rows
          # split vertically
          left_half_width = @columns/2
          left_half_width += 1 if (@columns % 2) != 0
          right_half_width = @columns - left_half_width
          @children << GridLayout.new("#{left_half_width}x#{@rows}", x: x, y: y)
          @children << GridLayout.new("#{right_half_width}x#{@rows}",x: left_half_width, y: y)
          return true
        else
          # split horizontally
          top_half_height = @rows/2
          top_half_height += 1 if (@rows % 2) != 0
          bottom_half_height = @rows - top_half_height
          @children << GridLayout.new("#{@columns}x#{top_half_height}", x: x, y: y)
          @children << GridLayout.new("#{@columns}x#{bottom_half_height}", x: x, y: top_half_height)
          return true
        end
      else
        # spliting children in random fasion
        # get ramddom value
        random = [0,1].sample
        # try splitting children at first ramddom value
        if @children[random].split_grid
          # firt attemp was sucessful
          return true
        else
          # firt attemp was not sucessful
          random = random - 1
          # try splitting children at other ramddom value
          return @children[random].split_grid
        end
      end
    end

    def self.new_2x2

    end


    def total_area
      total_area = 0
      if @children.length > 1
        @children.each do |child|
          total_area += child.total_area
        end
      else
        total_area = @columns*@rows
      end
      total_area
    end

    def to_svg
      svg_sting =""
      frames.each do |frame|
        svg_sting += frame.to_svg
      end
      style ="style=\"fill:white;stroke-color:red;stroke-width:3\""

      s= <<-EOF.gsub(/^\s*/, "")
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


    def flip_vertically
      height = @rows
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
        frame.flip_horizontally(@columns)
      end
      @patterns = @frames.map{|f| f.frame}
    end

    def flip_both_way
      flip_horizontally
      flip_vertically
    end

  end


  # ==============================  GRID_PATTERNS  =============================
  GRID_PATTERNS = {
    '1x1/1'=>[[0, 0, 1, 1]],
    '1x2/2'=>[[0, 0, 2, 1], [0, 1, 2, 1]],
    '2x2/3'=>[[0, 0, 2, 1], [2, 0, 1, 2], [0, 1, 2, 1]],
    '2x2/4'=>[[0, 0, 1, 1], [1, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1]],
    '3x3/2'=>[[0, 0, 2, 2], [2, 2, 1, 1]],
    '3x3/3'=>[[0, 0, 1, 1], [1, 1, 1, 1], [2, 2, 1, 1]],
    '3x3/5'=>[[0, 0, 3, 1], [0, 1, 3, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]],
    '3x3/6'=>[[0, 0, 3, 1], [0, 1, 2, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]],
    '3x3/7'=>[[0, 0, 3, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]],
    '3x3/8'=>[[0, 0, 1, 1], [1, 0, 1, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 2, 1]],
    '3x3/8_1'=>[[0, 0, 1, 1], [1, 0, 1, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 2, 1], [2, 2, 1, 1]],
    '3x3/8_2'=>[[0, 0, 2, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]],
    '3x3/9'=>[[0, 0, 1, 1], [1, 0, 1, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]],
    # '4x7/2'=>[],
    # '4x7/3'=>[],
    # '4x7/4'=>[],
    # '4x7/5'=>[],
    # '4x7/6'=>[],
    # '4x7/7'=>[],
    '6x6/1'=>[[0, 0, 1, 1]],
    '6x6/3'=>[[0, 0, 1, 1], [0, 0, 1, 1], [0, 0, 1, 1]],
    '7x11/3'=>[[0, 0, 4, 6], [4, 0, 3, 6], [0, 6, 7, 5]],
    '7x11/4'=>[[0, 0, 4, 5], [4, 0, 3, 5], [0, 5, 3, 6], [3, 5, 4, 6]],
    '7x11/5'=>[[0, 0, 7, 3], [0, 3, 4, 3], [4, 3, 3, 4], [0, 6, 4, 5], [4, 7, 3, 4]],
    '7x11/6'=>[[0, 0, 4, 3], [4, 0, 3, 4], [0, 3, 4, 3], [4, 4, 3, 3], [0, 6, 4, 5], [4, 7, 3, 4]],
    '7x12/H/4'=>[[0, 0, 7, 1], [0, 1, 4, 4], [4, 1, 3, 4], [0, 5, 7, 2], [0, 7, 7, 5]],
    '7x12/4'=>[[0, 1, 4, 4], [4, 1, 3, 4], [0, 5, 7, 2], [0, 7, 7, 5]],
    '7x12/H/5'=>[[0, 0, 7, 1], [0, 1, 4, 3], [4, 1, 3, 4], [0, 4, 4, 5], [4, 5, 3, 4], [0, 9, 7, 3]],
    '7x12/5'=>[[0, 0, 7, 3], [0, 3, 4, 3], [4, 3, 3, 4], [0, 6, 4, 5], [4, 7, 3, 4]],
    '7x12/5_1'=>[[0, 0, 4, 3], [0, 3, 4, 3], [4, 0, 3, 6], [0, 6, 4, 6], [4, 6, 3, 6]],
    '7x12/5_2'=>[[0, 0, 7, 6], [0, 3, 4, 3], [4, 3, 3, 3], [0, 6, 4, 3], [4, 6, 3, 3]],
    '7x12/6'=>[[0, 0, 4, 3], [4, 0, 3, 5], [0, 3, 4, 2], [0, 5, 4, 2], [4, 5, 3, 2], [0, 7, 7, 5]],
    '7x12/6_1'=>[[0, 0, 4, 3], [0, 3, 4, 3], [4, 0, 3, 6], [0, 6, 4, 6], [4, 6, 3, 3], [4, 3, 3, 3]],
    '7x12/6_2'=>[[0, 0, 7, 6], [0, 6, 4, 3], [0, 3, 2, 3], [2, 3, 2, 3], [4, 6, 3, 3], [4, 3, 3, 3]],
    '7x12/7'=>[[0, 0, 7, 1], [0, 1, 4, 2], [4, 1, 3, 4], [0, 3, 4, 2], [0, 5, 4, 2], [4, 5, 3, 2], [0, 7, 7, 5]],
    '6x15/H/6'=>[[0, 0, 7, 1], [0, 1, 4, 4], [4, 1, 3, 3], [0, 5, 6, 2], [4, 5, 2, 3], [0, 10, 6, 5]],

  }

GRID_MAPPING = {
  '5dan-tong_6x15_H_4'=> '6x15/H/6'
}


  class GridPattern
    attr_accessor :grid_key, :grid_rects
    def initialize(grid_key, options={})
      @grid_key = grid_key
      @grid_rects = options[:grid_rects] if options[:grid_rects]
      self
    end

    def has_heading?
      grid_key.split("/")[1]=~/^H/ ? true : false
    end
  end

  class GridPatternManager
    def self.find_all
      grid_object_array = []
      GRID_PATTERNS.each do |item|
        grid_object_array << GridPattern.new(item[0], :patterns=>item[1])
      end
      grid_object_array
    end


    # sort given grid_layout_list by its total area
    def self.sort_by_area(grid_layout_list, options={})
      grid_layout_list.sort!{|x,y| x.total_area <=> y.total_area}
    end

    def self.find_with_grid_key(grid_key)
      GridPattern.new(grid_key, :patterns=>GRID_PATTERNS[grid_key])
    end

    # check if two arrays of frames are virtually equal,
    def self.has_equal_frames?(first, second)
      first.each do |frame|
        return false unless second.include?(frame)
      end
      true
    end
    # find all possible GridPattern with given number of grid_rects
    def self.find_with_number_of_frames(number_of_frames)
      candidates = []
      GRID_PATTERNS.each do |item|
        if item[0]=~/\/#{number_of_frames.to_s}(_\d)?$/
           candidates << item
        end
      end
      candidates.map{|f| GridPattern.new(f[0], :patterns=>f[1])}
    end

    def self.find_with_grid_base_and_number(grid_base, number_of_frames)
      candidates = []
      GRID_PATTERNS.each do |item|
        if item[0]=~/^#{grid_base}(H)?\/#{number_of_frames.to_s}(_\d)?$/
           candidates << item
        end
      end
      candidates.map{|f| GridPattern.new(f[0], :patterns=>f[1])}
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
        grid_layout = GridPattern.new(grid_key)
        a = grid_layout.flip_horizontally
        puts "flip_horizontally"
        puts a.to_s
        variations << a
        grid_layout = GridPattern.new(grid_key)
        b = grid_layout.dup.flip_vertically
        puts "flip_vertically"
        puts b.to_s
        variations << b
        grid_layout = GridPattern.new(grid_key)
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
