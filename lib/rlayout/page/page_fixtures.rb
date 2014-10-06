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
    
    def initialize(parent_graphic, options={})
      options[:text_size] = 8 unless options[:text_size]
      options[:text_font] = 'Helvetica' unless options[:text_size]
      super
      if @parent_graphic.left_page?
        @x      = @parent_graphic.left_margin
        @y      = @parent_graphic.top_margin - @text_size - 10 #TODO
        @width  = 300
        @text_alignment = 'left'
      else
        @width  = 300
        @x      = @parent_graphic.width - @width - @parent_graphic.right_margin # @right_margin
        @y      = @parent_graphic.top_margin - @text_size - 10 #TODO
        @text_alignment = 'right'
      end
      self
    end
  end
  
  class Footer < Text
    attr_accessor :chpater_front, :left, :right         # what_pages_to_display, 
    attr_accessor :position                             # sides, middle
    attr_accessor :left_side_string, :right_side_string # what to display, 
    attr_accessor :post_string, :page_number
    attr_accessor :pre_string, :post_string, :page_number
    
    def initialize(parent_graphic, options={})
      options[:text_size] = 8 unless options[:text_size]
      options[:text_font] = 'Helvetica' unless options[:text_size]
      
      super
      @text_alignment = 'center'
      @page_number = @parent_graphic.page_number
      @pre_string  = options.fetch(:pre_string, "-")
      @post_string = options.fetch(:post_string, "-")
      @text_string = @pre_string + " " + @page_number.to_s + " " + @post_string
      @width  = 300
      @height = 20
      @x = @parent_graphic.width/2 - @width/2
      @y = @parent_graphic.height - 50
      self
    end
    
  end
  
  class SideBar < Text
    attr_accessor :rotation 
    
    def initialize(parent_graphic, options={})
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