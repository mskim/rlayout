module RLayout


  # LeaderRow
  # create the table_row with leader_cell to fill the justified cells.
  # Fill the cell with leader char
  # sometext ................. some_ending
  # sometext_text ............ some_ending
  # sometext ............ some_ending_more
  # sometext ................. some_ending
  # sometext ...... some ..... some_ending
  # it is used in toc ,jubo, and munu 

  # TextCell = Text
  class LeaderRow < Container
    attr_reader :row_data, :leading_char
    attr_accessor :row_index
    def initialize(options={})
      options[:stroke_width] = 1
      super
      @row_index    = options[:row_index]
      @row_data     = options[:row_data]
      @leading_char = options[:leading_char] || "."
      create_text_cells
      insert_leader_cells
      align_cells
      self
    end

    def leader_style_object
      parent.leader_style_object
    end

    def align_cells
      x_position = 0
      @graphics.each_with_index do |g, i|
        g.row_index = @row_index
        g.column_index = i
        g.v_alignment = 'center'
        g.x = x_position
        x_position += g.width
        if i == 0
          # first text cell
          g.text_alignment = 'left'
        elsif i == @graphics.length - 1 
          # last text cell
          g.text_alignment = 'right'
        else
          g.text_alignment = 'center'
        end
      end
      cell_width_sum = graphic_width_sum
      room = cell_width_sum/@graphics.length - 1
      x_position = 0
      @graphics.each do |cell|
        cell.x = x_position
        x_position += cell.width + room
      end
    end

    # create text cell and calucate 
    def create_text_cells
      @row_data.each_with_index do |cell, i|
        h                     = {}
        h[:parent]            = self
        h[:layout_expand]     = nil
        h[:height]            = @height
        h[:layout_direction]  = 'horizontal'
        h[:string]            = cell
        h[:text_style]        = {font: 'Shinmoon', font_size: 12, text_color: 'black'}
        h[:style_name]        = tag || 'body'
        h[:style_name]        = 'subtitle'
        h[:v_alignment]       = 'top'
        h[:text_fit_type]     = 'fit_box_to_text'
        t = TextCell.new(h)
      end
    end

    def insert_leader_cells
      @leader_cell_count = @graphics.select{|c| c.class == TextCell}.length - 1
      leader_room = @width - text_cell_width_sum
      cell_width = leader_room/@leader_cell_count
      insert_position = 1
      @leader_cell_count.times do |i|
        h = {}
        # h[:parent]  = self
        h[:width]   = cell_width
        h[:height]  = @height
        h[:text_string] = "."
        l_cell = LeaderCell.new(h)
        l_cell.parent = self
        @graphics.insert(insert_position,l_cell)
        insert_position += 2
      end
    end
    
    def text_cell_width_sum
      @graphics.select{|c| c.is_a?(TextCell)}.map{|c| c.width}.reduce(:+)
    end

    def graphic_width_sum
      @graphics.map{|c| c.width}.reduce(:+)
    end

    def leader_cells
      @graphics.select{|c| c.is_a?(LeaderCell)}
    end
  end
end


