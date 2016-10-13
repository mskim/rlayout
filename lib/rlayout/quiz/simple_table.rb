module RLayout
  
  # TextCell is used to set alignment for TextToken is a cell
  class TextCell < Container
    attr_accessor :h_alignment, :v_alignment, :token
    attr_accessor :insert_leader_token, :atts
    def initialize(options={})
      super
      @layout_direction = "horizontal"
      @token          = options[:token]
      @atts           = options[:atts]
      @insert_leader_token = options.fetch(:insert_leader_token, false)
      @layout_length  = @width
      @h_alignment    = options.fetch(:h_alignment, "left")
      @v_alignment    = options.fetch(:v_alignment, "top")
      @height         = @token.height
      @token.parent_graphic = self
      @graphics << token
      align_token
      self
    end
    
    def align_token
      @margin = 2
      @space = @width - @token.width - @margin*2
      if @space <= @margin
        @x = 0
        return
      end
      
      case @h_alignment
      when 'left'
        @token.x = @margin
        if @insert_leader_token
          LeaderToken.new(parent: self, x: @margin + @token.width, width: @space, atts: @atts)
        end      
      when 'center'
        @token.x = @margin + @space/2 
      when 'right'
        @token.x = @margin + @space
        if @insert_leader_token
          LeaderToken.new(parent: self, x: @margin, width: @space, atts: @atts)
          @graphics.reverse!
        end      
      else
        @token.x = @margin
      end
      
    end
  end
  
  # item_row
  class SimpleTableRow < Container
    attr_accessor :items, :head_row, :has_head_column, :column_width_array, :column_align_array
    def initialize(options={})
      super
      @quiz_item_style = 
      RLayout::StyleService.shared_style_service.quiz_item_style
      
      @layout_direction   = "horizontal"
      @layout_expand      = :width
      @items              = options[:items]
      @head_row           = options.fetch(:head_row, false)
      @column_width_array = @quiz_item_style[:column_width_array]
      @column_align_array = @quiz_item_style[:column_align_array]
      @table_head_style   = @quiz_item_style[:table_head_style].dup
      @table_body_style   = @quiz_item_style[:table_body_style].dup
      @items.each_with_index do |item, i|
        if @head_row
          token = TextToken.new(string: item, atts: @table_head_style, layout_expand: :width)
          TextCell.new(parent: self, width: @column_width_array[i], token: token, h_alignment: "center", atts: @table_head_style)
        else
          token = TextToken.new(string:item, atts: @table_body_style, layout_expand: :width)
          TextCell.new(parent: self, width: @column_width_array[i], token: token, h_alignment: @column_align_array[i], insert_leader_token: true, atts: @table_body_style)
        end
      end
      self
    end
  end
  
  # similar to Table, but simpler
  # uniform cell atts using TextToken
  # comma separated file as input
  class SimpleTable < Container
    attr_accessor :has_heading, :header, :rows
    attr_accessor :body_styles, :has_head_column, :header_array
    def initialize(options={})
      super
      @csv_text           = options[:csv]
      @has_heading        = options.fetch(:has_heading, true)
      @has_head_column    = options.fetch(:has_head_column, false)
      if RUBY_ENGINE == 'rubymotion'
        @csv                 = MotionCSV.parse(@csv_text)
      else
        @csv                 = CSV.parse(@csv_text, headers: true)
        @header_array       = @csv.headers
      end
      @header_array       = @csv.headers
      if options[:column_width_array]
        @column_width_array = options[:column_width_array]
      else
        @column_width_array = make_column_width_array
      end
      if options[:column_align_array]
        @column_align_array = options[:column_align_array]
      else
        @column_align_array = make_column_align_array
      end
      # head row
      SimpleTableRow.new(parent: self, width: @width, height: 20, head_row: true, items: @header_array, column_width_array: @column_width_array, column_align_array: @column_align_array)
      # body rows
      @csv.each do |row|
        SimpleTableRow.new(parent: self, width: @width, height: 20, items: row, column_width_array: @column_width_array, column_align_array: @column_align_array)
      end
      layout_items
      self
    end
    
    def layout_items
      height_sum = @graphics.map{|g| g.height}.reduce(:+)
      @height   = height_sum + 4
      relayout!
    end
    
    def make_column_width_array
      width_ratio = [1, 6, 6, 6]
      # if width_ratio is given 
      if @table_head_style && @table_head_style[:column_width_array]
        width_ratio = @table_head_style[:column_width_array]
      end
      ratio_sum = width_ratio.reduce(:+)
      width_ratio.map{|w| w*@width/ratio_sum}
    end
    
    def make_column_align_array
      column_align_array = @header_array.map{|c| c="center"}
      row_count = column_align_array.length
      column_align_array = []
      if row_count == 1
        return column_align_array << 'center'
      end
      if row_count == 2
        column_align_array << 'center'
        column_align_array << 'center'
        return column_align_array
      end
      if row_count == 3
        column_align_array << 'right'
        column_align_array << 'left'
        column_align_array << 'left'
        return column_align_array
      end
      if row_count == 4
        column_align_array << 'right'
        column_align_array << 'left'
        column_align_array << 'left'
        column_align_array << 'right'
        return column_align_array
      end
      if @has_head_column
        column_align_array << 'right'
        column_align_array << 'left'
        row_count -=3
      else
        column_align_array << 'left'
        row_count -=2
      end
      if (row_count - 1) > 1
        (row_count - 1).times do
          column_align_array << 'center'
        end        
      end
      column_align_array << 'right'
      column_align_array
    end
  end
  
end
  
  
  