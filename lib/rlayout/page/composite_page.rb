
module RLayout
  class CompositePage < Page
    attr_accessor :project_path
    attr_accessor :composites, :grid_width, :grid_height, :h_gutter, :v_gutter
    
    def initialize(paraent_graphic, options={})
      super
      @project_path = options[:project_path]
      @h_gutter     = options.fetch(:h_gutter, 5)
      @v_gutter     = options.fetch(:v_gutter, 5)
      @h_grid_count = options.fetch(:h_grid_count, 6)
      @v_grid_count = options.fetch(:v_grid_count, 12)
      @grid_width   = (text_rect[2] - @h_gutter*(@h_grid_count-1))/@h_grid_count
      @grid_height  = (text_rect[3] - @v_gutter*(@v_grid_count-1))/@v_grid_count
      @composites   = options[:composites]
      create_composite_area
      self
    end
    
    def create_composites
      @composites.each do |composite|
        composite[:width] = make_width
        options = translate_grid_cordinate(composite)
        options[:parent] = self
        Image.new(options)
      end
    end
    
    # translate grid cordinate to points
    def translate_grid_cordinate(composite)
      h_gutter_sum      = composite[:rect][0]*@h_gutter      
      v_gutter_sum      = composite[:rect][1]*@v_gutter
      options[:x]       = composite[:rect][0]*@grid_width + h_gutter_sum
      options[:y]       = composite[:rect][1]*@grid_width + v_gutter_sum
      options[:width]   = composite[:rect][2]*@grid_width
      options[:height]  = composite[:rect][3]*@grid_width
      options[:image_path] = 
      options
    end
    
    def update_composites
      
    end
    
  end  
  
  
end