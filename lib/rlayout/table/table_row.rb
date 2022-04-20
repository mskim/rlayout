module RLayout

  class TableRow < Container
    attr_accessor :row_type, :fit_type, :font
    attr_accessor :column_sytle_array, :column_alignment
    attr_reader :para_style
    attr_reader :row_index
    def initialize(options={}, &block)
      options[:stroke_width] = 1
      options[:stroke_sides] = [0,1,0,1]
      options[:fill_color]    = "black"
      options[:height]    = options[:height] || 20
      super
      @row_index = options[:row_index]
      @width              = parent.width if parent
      @para_style         = options[:para_style]
      @cell_atts          = options[:cell_atts] || {}
      @row_data           = options[:row_data]
      @row_type           = options.fetch(:row_type, "body_row")
      @fit_type           = options.fetch(:fit_type, "adjust_row_height")
      @layout_direction   = 'horizontal'
      @column_width_array = options[:column_width_array] || []
      
      current_style = RLayout::StyleService.shared_style_service.current_style
      if current_style.class == String
        current_style = YAML::load(current_style)
      end
      style_hash = current_style['body']
      style_hash = current_style['body_gothic'] if @row_type != 'body_row'
      @para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      @cell_x  = 0

      @row_data.each_with_index do |cell_text, i|
        @cell_atts[:text_string]    = cell_text
        @cell_atts[:para_style]     = @para_style
        if options[:column_width_array]
          cell_unit_width_sum = @column_width_array.reduce(:+)
          cell_width          = @width*@column_width_array[i]/cell_unit_width_sum 
          @cell_atts[:x]      = @cell_x
          @cell_atts[:width]  = cell_width
          @cell_atts[:height]  = 12
          @cell_atts[:layout_length]  = cell_width
          @cell_atts[:fill_color]  = 'gray'

          @cell_x += cell_width
        else
          @column_width_array << 1
        end
        if @cell_atts[:stroke_sides]
          cell_sides_type           = @cell_atts[:stroke_sides].length 
          case cell_sides_type
          when 4
            # do noting. This is single array [0,0,0,0]
          when 3
            # this is when left most, middle, right most are different
            # [[0,0,1,0], [1,0,1,0], [1,0,0,0]]
            if i == 0
              @cell_atts[:stroke_sides] = @cell_atts[:stroke_sides][0]
            elsif i == (@row_data.length - 1)
              @cell_atts[:stroke_sides] = @cell_atts[:stroke_sides][2]
            else
              @cell_atts[:stroke_sides] = @cell_atts[:stroke_sides][1]
            end
          when 2
            # this is right of left most column
            # [[0,0,1,0], [0,0,0,0]]
            if i == 0
              @cell_atts[:stroke_sides] = @cell_atts[:stroke_sides][0]
            else
              @cell_atts[:stroke_sides] = @cell_atts[:stroke_sides][1]
            end
          when 1
            # this is nested case, just flatten it
            # [[0,0,1,0]]
            @cell_atts[:stroke_sides] = @cell_atts[:stroke_sides][0]
          end

        end
        # binding.pry
        table_cell = td(@cell_atts)
      end
      case @fit_type
      when 'adjust_row_height'
        # find tallest cell and adjust height to accomodate it.
        @height = tallest_cell_height + 4
      else
        # we might have to sqeeze in the cells to fit???
      end
      adjust_height
      self
    end
    
    def cycle_color
      %w[ #F9DED7 #CCE1FE  #C6F8E5 ]
      # %w[#FBF7D5 #F9DED7 #CCE1FE  #C6F8E5 #F5DCDE]
    end

    def row_cycle_color
      mod = @row_index % cycle_color.length
      cycle_color[mod]
    end

    def adjust_height
      @height = tallest_cell_height + 1
    end
    
    def td(options={})
      options[:fill_color]        = 'clear'
      options[:stroke_thickness]  = 1
      options[:text_fit_type]     = 'adjust_box_height'
      options[:parent]            = self
      if @row_type == "head_row"
        options[:fill_color]        = 'gray'
        options[:stroke_thickness]  = 1 
        options[:style_name]  = 'body_gothic'
        tc = TextCell.new(options)
      else
        options[:fill_color]  = row_cycle_color
        options[:style_name]  = 'body'
        # binding.pry
        tc = TextCell.new(options)
      end
      self
    end
    
    def tallest_cell_height
      tallest_height = @graphics.first.height
      @graphics.each do |graphic|
        tallest_height = graphic.height if graphic.height > tallest_height
      end
      tallest_height
    end
  end
  
end