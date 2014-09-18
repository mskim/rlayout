module RLayout
  
  # TextColumn. 
  # Paragraphs are layed out out in TextColumn. Paragraphs have many TextLines.
  # Line_grids are used to vertical align TextLines. Body text_lines should align TextLines of adjacent TextColumns.
  # When a heading paragraph, which has different line heights, is layed in the middle of the column, 
  # it will throw off vertical alingment of body text, misalinment of body text with adjacent columns.
  # Body text, after the heading, should snap its location to line_grids.
  # This feature is requested feature for newspaper and magazines publishing, where texts are layed in multiple columns.
  # line_grids are set with absolute height, not numbers of them
  # This is because, line heights determine the height of body text font size.
  # Font size of body text is determined by the height of the line_grids.
  # line_grid = TextLines.height + leading,  body font size is derived from this, not the other way around.
  
  # relayout! for TextColumn
  # relayout! is overidden to implement snaping to grid and vertical alignment
  
  class  TextColumn < ColumnObject
    attr_accessor :line_grid_y, :line_grid_height, :line_grid_offset
    attr_accessor :current_position
    def initialize(parent_graphic, options={}, &block)
      super
      
      @line_grid_height = options.fetch(:line_grid_height, 30)
      @line_grid_offset = options.fetch(:line_grid_offset, 0)
      @current_position = @line_grid_offset
      if block
        instance_eval(&block)
      end
      self
    end
    
    def line_grid_count
      @height/@line_grid_height.to_i
    end
    
    def line_grid_rects
      grid_rects = []
      line_grid_count.times do |i|
        line_grid_y = i*@line_grid_height + @line_grid_offset
        grid_rects << [0,line_grid_y, @width,@line_grid_height]
      end
      grid_rects
    end
        
    def snap_current_position_to_next_grid(item_height)
      # set new @current_position
      line_grid_count.times do |i|
        line_grid_y = i*@line_grid_height + @line_grid_offset
        unless line_grid_y < @current_position + item_height
          @current_position = line_grid_y
          return
        end
      end
    end
    
    # insert paragraph to column
    # check if the markup is p or body
    # if so, smap paragraph lines to line grid, make the line height to fit to line_grid
    def insert_item(item, options={})
      
      # we have Paragraph
      if ((item.height + @layout_space + @current_position) <= @height) || (options[:fortce_fit]==true)
        # insert item
        item.parent_graphic = self
        item.y = @current_position
        item.x = @left_margin + @left_inset
        
        @graphics << item
        snap_current_position_to_next_grid(item.height)

        true
      else
        # cant't insert 
        return false
      end
    end
    
    def insert_part(part, options={})
      # for now we just use insert_item
      # I might need to do something different when inserting parts?
      insert_item(part, options={})
    end
    
    # # snap it to grid, vertical alignment
    # def relayout!
    #   
    # end
  end
  
end