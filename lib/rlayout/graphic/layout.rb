module RLayout
  
  
  class Graphic
    def init_layout(options)
      @left_margin    = options.fetch(:left_margin, layout_default[:left_margin])
      @top_margin     = options.fetch(:top_margin, layout_default[:top_margin])
      @right_margin   = options.fetch(:right_margin, layout_default[:right_margin])
      @bottom_margin  = options.fetch(:bottom_margin, layout_default[:bottom_margin])
      @left_inset     = options.fetch(:left_inset, layout_default[:left_inset])
      @top_inset      = options.fetch(:top_inset, layout_default[:top_inset])
      @right_inset    = options.fetch(:right_inset, layout_default[:right_inset])
      @bottom_inset   = options.fetch(:bottom_inset, layout_default[:bottom_inset])
      @layout_direction = options.fetch(:layout_direction, layout_default[:layout_direction])
      @layout_member    = options.fetch(:layout_member, layout_default[:layout_member])
      @layout_expand    = options.fetch(:layout_expand, layout_default[:layout_expand])
      @layout_length    = options.fetch(:layout_length, layout_default[:layout_length])

      # convert unit to point if they are in cm or mm
      @x              = convert_to_pt(@x)           if @x.class == String
      @y              = convert_to_pt(@y)           if @y.class == String
      @width          = convert_to_pt(@width)       if @width.class == String
      @height         = convert_to_pt(@height)      if @height.class == String
      @left_margin    = convert_to_pt(@left_margin) if @left_margin.class == String
      @top_margin     = convert_to_pt(@top_margin)  if @top_margin.class == String
      @right_margin   = convert_to_pt(@right_margin)if @right_margin.class == String
      @bottom_margin  = convert_to_pt(@bottom_margin)if @bottom_margin.class == String
      @left_inset     = convert_to_pt(@left_inset)  if @left_inset.class == String
      @top_inset      = convert_to_pt(@top_inset)   if @top_inset.class == String
      @right_inset    = convert_to_pt(@right_inset) if @right_inset.class == String
      @bottom_inset   = convert_to_pt(@bottom_inset)if @bottom_inset.class == String
    end
    
    def layout_default
      {
        left_margin:  0,
        top_margin:   0,
        right_margin: 0,
        bottom_margin: 0,
        left_inset:   0,
        top_inset:    0,
        right_inset:  0,
        bottom_inset: 0,
        layout_direction: "vertical",
        layout_member: true,
        layout_expand: [:width, :height], # auto_layout expand 
        layout_length:  1,
      }
    end
    
    def layout_to_hash
      layout_default_hash = layout_default
      h = {}
      h[:left_margin]   = @left_margin if @left_margin != layout_default_hash[:left_margin]
      h[:top_margin]    = @top_margin if @top_margin != layout_default_hash[:top_margin]
      h[:right_margin]  = @right_margin if @right_margin != layout_default_hash[:right_margin]
      h[:bottom_margin] = @bottom_margin if @bottom_margin != layout_default_hash[:bottom_margin]
      h[:left_inset]    = @left_inset if @left_inset != layout_default_hash[:left_inset]
      h[:top_inset]     = @top_inset if @top_inset != layout_default_hash[:top_inset]
      h[:right_inset]   = @right_inset if @right_inset != layout_default_hash[:right_inset]
      h[:bottom_inset]  = @bottom_inset if @bottom_inset != layout_default_hash[:bottom_inset]
      h[:layout_direction] = @layout_direction if @layout_direction != layout_default_hash[:layout_direction]
      h[:layout_member] = @layout_member if @layout_member != layout_default_hash[:layout_member]
      h[:layout_expand] = @layout_expand if @layout_expand != layout_default_hash[:layout_expand]
      h[:layout_length] = @layout_length if @layout_length != layout_default_hash[:layout_length]
      h
    end
  end
end