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
      options[:font_size] = 8 unless options[:font_size]
      options[:font]    = 'Helvetica' unless options[:font_size]
      options[:text_string] = "" if options[:text_string].nil?
      if @parent
        options[:y]       = @parent.top_margin - options[:height]  
      else
        options[:y]       = 30 - options[:font_size]  
      end    
      options[:width]   = 300
      options[:height]  = 20
      @parent   = options[:parent]
      if @parent.left_page?
        options[:x]     = @parent.left_margin
        options[:text_alignment] = 'left'
      else
        options[:x]     = @parent.width - options[:width] - @parent.left_margin - @parent.left_inset
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
      @parent     = options[:parent]
      options[:font_size] = 8 unless options[:font_size]
      options[:font]      = 'Helvetica' unless options[:font_size]
      options[:width]     = 300
      options[:height]    = 20
      options[:text_string] = "" if options[:text_string].nil?
      options[:y]         = @parent.height - @parent.bottom_margin + 4     
      @page_number        = @parent.page_number
      @pre_string         = options.fetch(:pre_string, "-")
      @post_string        = options.fetch(:post_string, "-")
      @parent     = options[:parent]
      if @parent.page_number.even?
        options[:x] = @parent.left_inset + @parent.left_margin
        options[:text_alignment] = 'left'
        options[:text_string] = @page_number.to_s + " " + options[:text_string]
      else
        options[:x] = @parent.width - options[:width] - @parent.left_margin - @parent.left_inset
        options[:text_alignment] = 'right'
        options[:text_string] += " " + @page_number.to_s
      end
      super
      if @parent && !@parent.floats.include?(self)
        @parent.floats << self
      end
      self
    end
    
  end
  
  class SideBar < Text
    attr_accessor :rotation 
    
    def initialize(options={})
      super
      if @parent.left_page?
        @x = 0
        @y = 30
        @rotation = -90
      else
        @x = @parent.width - 30
        @y = 30
        @rotation = 90
      end
      self
    end
  end
  
end