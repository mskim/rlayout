module RLayout
  
  # TextCell is used to set alignment for TextToken is a cell
  class TextCell < Container
    attr_accessor :h_alignment, :v_alignment
    
    def initialize(options={})
      @h_alignment = options.fetch(:h_alignment, "left")
      if options[:text_token]
        options[:text_token].parent_graphic = self
        @graphics << options[:text_token]
      end    
      self
    end
  end
  
  # item_row
  class SimpleTableRow < Container
    attr_accessor :items, :head_row
    def initialize(options={})
      super
      @layout_direction = "horizontal"
      @layout_expand    = :width
      @items            = options[:items]
      @head_row         = options.fetch(:head_row, false)
      @table_head_style  = $quiz_item_style[:table_head_style].dup
      @table_body_style  = $quiz_item_style[:table_body_style].dup
      @items.each do |item|
        if @head_row
          TextToken.new(parent: self, text_string:item, atts: @table_head_style, layout_expand: :width)
        else
          TextToken.new(parent: self, text_string:item, atts: @table_body_style, layout_expand: :width)
        end
      end
      layout_items
      self
    end
    
    def layout_items
      margin = 10
      x= margin
      @cell_width_array = @graphics.map {|g| g.width}
      if @table_head_style[:cell_width_array]
        @cell_width_array = table_head_style[:cell_width_array]
      end
      item_width_sum = @graphics.map {|g| g.width}.reduce(:+)
      space = (@width - item_width_sum - margin*2)/(@graphics.length - 1)
      @graphics.each do |g|
        g.x = x
        x +=g.width + space
      end
    end
  end
  
  # similar to Table, but simpler
  # uniform cell atts using TextToken
  # comma separated file as input
  class SimpleTable < Container
    attr_accessor :has_heading, :header, :rows
    attr_accessor :body_styles
    def initialize(options={})
      super
      @csv_text = options[:csv]
      @has_heading = options.fetch(:has_heading, true)
      csv = MotionCSV.parse(@csv_text)
      SimpleTableRow.new(parent: self, width: @width, height: 20, head_row: true, items: csv.headers)
      csv.each do |row|
        SimpleTableRow.new(parent: self, width: @width, height: 20, items: row, stroke_width: 1)
      end
      layout_items
      self
    end
    
    def layout_items
      height_sum = @graphics.map{|g| g.height}.reduce(:+)
      @height   = height_sum + 4
      relayout!
    end
  end
  
  
end
  
  
  