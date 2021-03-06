IMAGE_PATTERNS = {
  "1/1x1/1"=>[[0, 0, 1, 1]], 
  "2/1x2/1"=>[[0, 0, 2, 1], [0, 1, 2, 1]], 
  "2/2x1/2"=>[[0, 0, 2, 1], [1, 0, 2, 1]], 
  "2/2x2/3"=>[[0, 0, 2, 1], [0, 1, 2, 1]], 
  "2/2x2/4"=>[[0, 0, 1, 2], [1, 0, 1, 2]], 
  "2/3x3/5"=>[[0, 0, 2, 2], [0, 2, 2, 1]], 
  "2/3x3/6"=>[[0, 0, 2, 1], [0, 1, 2, 2]], 
  "3/2x2/1"=>[[0, 0, 2, 1], [0, 1, 1, 2], [1, 1, 1, 1]], 
  "3/2x2/2"=>[[0, 0, 1, 1], [1, 0, 1, 1], [1, 1, 2, 1]], 
  "3/3x3/3"=>[[0, 0, 1, 1], [1, 1, 1, 1], [2, 2, 1, 1]], 
  "4/2x2/1"=>[[0, 0, 1, 1], [1, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1]], 
  "5/3x2/1"=>[[0, 0, 1, 1], [1, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1],[2,0,1,2]], 
  "5/3x2/2"=>[[0, 0, 1, 1, 5], [1, 0, 1, 1, -5], [0, 1, 1, 1, -5], [1, 1, 1, 1, 5],[2,0,1,2]], 
  "6/3x2/1"=>[[0, 0, 1, 1], [1, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1],[2,0,1,1], [2,1,1,1]], 
  "8/4x2/1"=>[[0, 0, 1, 1], [1, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1],[0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [3, 1, 1, 1]], 
  "9/3x3/1"=>[[0, 0, 1, 1], [1, 0, 1, 1], [2, 0, 1, 1], [0, 1, 1, 1],[1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2,2,1,1]], 
}
  
#   "3x3/2"=>[[0, 0, 2, 2], [2, 2, 1, 1]], 
#   "3x3/3"=>[[0, 0, 1, 1], [1, 1, 1, 1], [2, 2, 1, 1]], 
#   "3x3/5"=>[[0, 0, 3, 1], [0, 1, 3, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]], 
#   "3x3/6"=>[[0, 0, 3, 1], [0, 1, 2, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]], 
#   "3x3/7"=>[[0, 0, 3, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]], 
#   "3x3/8"=>[[0, 0, 1, 1], [1, 0, 1, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 2, 1]], 
#   "3x3/8_1"=>[[0, 0, 1, 1], [1, 0, 1, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 2, 1], [2, 2, 1, 1]], 
#   "3x3/8_2"=>[[0, 0, 2, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]], 
#   "3x3/9"=>[[0, 0, 1, 1], [1, 0, 1, 1], [2, 0, 1, 1], [0, 1, 1, 1], [1, 1, 1, 1], [2, 1, 1, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]], 
#   "6x6/1"=>[[0, 0, 1, 1]], 
#   "6x6/3"=>[[0, 0, 1, 1], [0, 0, 1, 1], [0, 0, 1, 1]], 
#   "7x11/3"=>[[0, 0, 4, 6], [4, 0, 3, 6], [0, 6, 7, 5]], 
#   "7x11/4"=>[[0, 0, 4, 5], [4, 0, 3, 5], [0, 5, 3, 6], [3, 5, 4, 6]], 
#   "7x11/5"=>[[0, 0, 7, 3], [0, 3, 4, 3], [4, 3, 3, 4], [0, 6, 4, 5], [4, 7, 3, 4]], 
#   "7x11/6"=>[[0, 0, 4, 3], [4, 0, 3, 4], [0, 3, 4, 3], [4, 4, 3, 3], [0, 6, 4, 5], [4, 7, 3, 4]], 
#   "7x12/H/4"=>[[0, 0, 7, 1], [0, 1, 4, 4], [4, 1, 3, 4], [0, 5, 7, 2], [0, 7, 7, 5]], 
#   "7x12/4"=>[[0, 1, 4, 4], [4, 1, 3, 4], [0, 5, 7, 2], [0, 7, 7, 5]], 
#   "7x12/H/5"=>[[0, 0, 7, 1], [0, 1, 4, 3], [4, 1, 3, 4], [0, 4, 4, 5], [4, 5, 3, 4], [0, 9, 7, 3]], 
#   "7x12/5"=>[[0, 0, 7, 3], [0, 3, 4, 3], [4, 3, 3, 4], [0, 6, 4, 5], [4, 7, 3, 4]], 
#   "7x12/H/6"=>[[0, 0, 7, 1], [0, 1, 4, 2], [4, 1, 3, 4], [0, 3, 4, 2], [0, 5, 4, 2], [4, 5, 3, 2], [0, 7, 7, 5]], 
#   "7x12/6"=>[[0, 1, 4, 2], [4, 1, 3, 4], [0, 3, 4, 2], [0, 5, 4, 2], [4, 5, 3, 2], [0, 7, 7, 5]], 
#   "7x12/7"=>[[0, 0, 7, 1], [0, 1, 4, 2], [4, 1, 3, 4], [0, 3, 4, 2], [0, 5, 4, 2], [4, 5, 3, 2], [0, 7, 7, 5]]]
# 
# ImageBox is a convient way to place multiple images on to page
#  

module RLayout
	class ImageBox < Container
	  attr_accessor :image_group_path, :images, :used_image_count, :h_gutter, :v_gutter
	  attr_accessor :grid_base, :grid_frames, :profile, :image_style, :grid_width, :grid_height
	  def initialize(options={})
	    super
	    @image_pattern  = options.fetch(:image_pattern, nil)
	    @profile        = options.fetch(:profile, nil)
	    @grid_base      = []
	    @h_gutter       = options.fetch(:h_gutter, 0)
      @v_gutter       = options.fetch(:v_gutter, 0)
	    @image_group_path = options.fetch(:image_group_path, "#{$ProjectPath}/images")
	    @images         = Dir.glob("#{@image_group_path}/*{.jpg,.pdf,.tiff}")	    
	    layout_images   if options[:layout_images]
	    @image_style    = options[:image_style] if options[:image_style]
	    self
	  end
	  
	  def layout_images!
	    pattern = {}
      if @image_pattern
	      pattern = @image_pattern
	      @profile = @image_pattern.keys.first
	      @used_image_count = @profile.split("/")[0].to_i
      elsif @profile && IMAGE_PATTERNS[@profile]
	      pattern = {@profile => IMAGE_PATTERNS[@profile]}
	      @used_image_count = @profile.split("/")[0].to_i
      else
        @used_image_count = @images.length
        IMAGE_PATTERNS.each do |k,v|
          if k =~/^#{cell_count}/
            pattern = {k=>v} 
          end
        end
      end
      
      if pattern == {}
        # if no pattern is found, create one
        # set grid_base[0], grid_base[1]
        adjust_columns_and_rows_for(@images.length)
	      make_grid_frames
      else
	      @grid_frames  = pattern.values.first
	      @grid_base[0] = pattern.keys[0].split("/")[1].split("x")[0].to_i
	      @grid_base[1] = pattern.keys[0].split("/")[1].split("x")[1].to_i
      end
	    @grid_width      = (@width - @left_margin - @right_margin - @left_inset - @right_inset - (@grid_base[0] - 1)*@h_gutter)/@grid_base[0].to_f 
	    @grid_height     = (@height - @top_margin - @bottom_margin - @top_inset - @bottom_inset - (@grid_base[1] - 1)*@v_gutter)/@grid_base[1].to_f 
	    @used_image_count.times do |i|
	      image = @images[i]
	      options           = {}
	      options[:x]       = @grid_frames[i][0]*@grid_width 
	      options[:x]       += @grid_frames[i][0]*@h_gutter if @grid_frames[i][0] > 0
	      options[:y]       = @grid_frames[i][1]*@grid_height # add gutter
	      options[:y]       += @grid_frames[i][1]*@h_gutter if @grid_frames[i][1] > 0
	      options[:width]   = @grid_frames[i][2]*@grid_width + (@grid_frames[i][2] - 1)*@h_gutter
	      options[:height]  = @grid_frames[i][3]*@grid_height + (@grid_frames[i][3] - 1)*@v_gutter
        options[:rotation]= @grid_frames[i][4] if @grid_frames[i].length > 4
	      options[:image_path] = image
	      options.merge!(@image_style) if @image_style
	      options[:parent]  = self
	      Image.new(options)
      end
	  end
	  
	  # make grid_frames of size 1x1 for columns(grid_base[0]) and rows(grid_base[1])
	  def make_grid_frames
	    @grid_frames = []
	    @grid_base[1].times do |j|
  	    @grid_base[0].times do |i|
	        @grid_frames << [i,j,1,1]
	      end
      end
	  end
	  
	end

end