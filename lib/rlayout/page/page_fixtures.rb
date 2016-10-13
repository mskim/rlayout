module RLayout
  
  # chpater_front_only, 
  # every_page, 
  # every_page_except_chapter_front
  # left_only
  # right_only
  class Header < Text
    attr_accessor :chpater_front, :left, :right         # what_pages_to_display, 
    attr_accessor :left_side_string, :right_side_string # what to display, 
    attr_accessor :post_string, :page_number
    
    def initialize(options={})
      options[:text_size] = 8 unless options[:text_size]
      options[:font]    = 'Helvetica' unless options[:text_size]
      options[:text_string] = "" if options[:text_string].nil?
      if @parent_graphic
        options[:y]       = @parent_graphic.top_margin - options[:height]  
      else
        options[:y]       = 30 - options[:text_size]  
      end    
      options[:width]   = 300
      options[:height]  = 20
      @parent_graphic   = options[:parent]
      if @parent_graphic.left_page?
        options[:x]     = @parent_graphic.left_margin
        options[:text_alignment] = 'left'
      else
        options[:x]     = @parent_graphic.width - options[:width] - @parent_graphic.left_margin - @parent_graphic.left_inset
        options[:text_alignment] = 'right'
      end
      super
      self
    end
  end
  
  class Footer < Text
    attr_accessor :chpater_front, :left, :right       
    attr_accessor :position                             # sides, middle
    attr_accessor :left_side_string, :right_side_string # what to display, 
    attr_accessor :post_string, :page_number
    attr_accessor :pre_string, :post_string
    
    def initialize(options={})
      @parent_graphic     = options[:parent]
      options[:text_size] = 8 unless options[:text_size]
      options[:font]      = 'Helvetica' unless options[:text_size]
      options[:width]     = 300
      options[:height]    = 20
      options[:text_string] = "" if options[:text_string].nil?
      options[:y]         = @parent_graphic.height - @parent_graphic.bottom_margin + 4     
      @page_number        = @parent_graphic.page_number
      @pre_string         = options.fetch(:pre_string, "-")
      @post_string        = options.fetch(:post_string, "-")
      @parent_graphic     = options[:parent]
      if @parent_graphic.page_number.even?
        options[:x] = @parent_graphic.left_inset + @parent_graphic.left_margin
        options[:text_alignment] = 'left'
        options[:text_string] = @page_number.to_s + " " + options[:text_string]
      else
        options[:x] = @parent_graphic.width - options[:width] - @parent_graphic.left_margin - @parent_graphic.left_inset
        options[:text_alignment] = 'right'
        options[:text_string] += " " + @page_number.to_s
      end
      super
      if @parent_graphic && !@parent_graphic.floats.include?(self)
        @parent_graphic.floats << self
      end
      self
    end
    
  end
  
  class SideBar < Text
    attr_accessor :rotation 
    
    def initialize(options={})
      super
      if @parent_graphic.left_page?
        @x = 0
        @y = 30
        @rotation = -90
      else
        @x = @parent_graphic.width - 30
        @y = 30
        @rotation = 90
      end
      self
    end
  end
  
end