module RLayout
  
  # RLeaderTable is fixed size table for Jubo, Toc, and Menu.
  # LeaderRow is a special row that inserts LeaderCell between TextCells. to make it look like following.

  # start_text ............................ end_text
  # start_text ........ middle_text ....... end_text
  # start_text ........ middle_text ....... end_text
  # start_text ............................ end_text
  # start_text ............................ end_text
  # start_text ............................ end_text
  # start_text ........ middle_text ....... end_text
  # start_text ........ middle_text ....... end_text
  # start_text ............................ end_text
  # start_text ............................ end_text

  class RLeaderTable < Container
    attr_reader :kind, :data
    attr_reader :body_styles
    attr_reader :table_data, :table_style
    attr_reader :style_serice, :leader_style_object

    def initialize(options={})
      options[:stroke_width] = 1
      super
      @pdf_doc = @parent.pdf_doc if @parent
      @table_data = options[:table_data]
      if options[:box_text_style]
        @box_text_style = options[:box_text_style]
        RLayout::StyleService.shared_style_service.current_style = @box_text_style
      elsif options[:box_text_style_path]
        RLayout::StyleService.shared_style_service.current_style = YAML::load_file(options[:box_text_style_path])
      end
      set_style
      set_leader_style_object
      @row_count  = @table_data.length
      create_rows
      self
    end

    def set_leader_style_object
      h = {}
      h[:font]                = @font       || 'KoPubDotumPL'
      h[:font_size]           = @font_size  || 12
      h[:tracking]            = @tracking   || 0     
      h[:scale]               = @scale      || 100  
      h
      @current_style_service = RLayout::StyleService.shared_style_service
      @leader_style_object = @current_style_service.style_object_from_para_style(h) 

    end

    def create_rows
      y_position = 0
      row_height = @height/@table_data.length
      @table_data.each_with_index do |row, i|
        h                 = {}
        h[:parent]        = self
        h[:layout_direction] = 'horizontal'
        h[:y]             = y_position
        h[:width]         = @width
        h[:height]        = row_height
        h[:layout_expand] = [:height]
        h[:row_data]      = row
        h[:row_index]     = i
        RLayout::LeaderRow.new(h)
        y_position += row_height
      end
    end
    
    def default_cell_graphic_style
      {fill_color: 'yellow', stroke_color: 'black', stroke_width: 1}
    end

    def default_cell_text_style

    end
    
    def set_style
      # set body row style
      if @row_styles && @row_styles.length > 0
        @graphics._with_index do |row, i|
          if i <= @heading_level
            # set heading row style

          end
          @row_styles.each_index do |row_style, i|
            @graphics[i].set_graphics_style
          end
        end
      end

      if @category_styles && @category_styles.length > 0
        @graphics._with_index do |row, i|
          if i <= @heading_level
            # set heading category style

          end
          @category_styles.each_index do |category_style, i|
            @graphics[i].set_graphics_style
          end
        end
      end      
      
      # @shape        = @table_style[:shape_hash]        || {shape:'rectangle'}
      # @fill_hash    = @table_style[:fill_hash]    || {fill_color:'red'}
      # @stroke_hash  = @table_style[:stroke_hash]  || {stroke_color:'black', stroke_width: 1}
    end

    def graphic_style_of_cell(colum_index, row_index)


    end

    def text_style_of_cell(colum_index, row_index)


    end
    
    def row_count
      @graphics.length
    end

    def link_info
      info = @graphics.map do |row|
        h = {}
        h[:x] = row.x + @x
        h[:y] = row.y + @y
        h[:width] = row.width
        h[:height] = row.height
        # h[:page_number] = row.graphics.last.text_string
        h[:link_text] = row.graphics.last.text_string
        h
      end
      info
    end
  end

end

