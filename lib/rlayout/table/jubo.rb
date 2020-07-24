module RLayout

  class Jubo < Container
    attr_reader :csv

    def initialize(options={})
      @csv = options[:csv]
      create_rows
      self
    end

    def create_rows
      rows = CSV.parse(@sample)
      rows.each do |r|
        LeaderRow.new(parent:self, row_data:r)
      end
    end
  end

  # LeaderRow
  # table row with leading filler chars
  # LederRow has left middle right text and filling leader char in between
  # left......middle.......right
  # 찬송기......235.......right

  # it is used in table of conten ,jubo, and munu 
  class LeaderRow < Container
    attr_reader :row_data, :leading_char

    def initialize(options={})
      super
      @row_data     = options[:row_data]
      @leading_char = options[:leading_char] || "."
      create_cells
      self
    end

    def create_cells
      if @row_data.length == 2
        TableCell.new(parent:self, cell_data:@row_data[0])
        LeaderCell.new(parent:self, cell_data:'.')
        TableCell.new(parent:self, cell_data:@row_data[1])
      elsif @row_data.length == 3
        TableCell.new(parent:self, cell_data:@row_data[0])
        LeaderCell.new(parent:self, cell_data:'.')
        TableCell.new(parent:self, cell_data:@row_data[1])
        LeaderCell.new(parent:self, cell_data:'.')
        TableCell.new(parent:self, cell_data:@row_data[2])
      end
      relayout!
    end
  end

  class LeaderCell < Graphic
    attr_reader :leader_char , :string
    def initialize(options={})
      @leader_char  = options[:leader_char] || '.'
      @string       = options[:string] || @leader_char*3
      @width        = options[:width]

      self
    end
  
    def draw_text(canvas)
      if @string.length > 0 && @para_style
        font_name = @para_style[:font] 
        size = @para_style[:font_size]
        text_color = @para_style[:text_color]
        text_color = "CMYK=0,0,0,100" unless text_color
        text_color = RLayout::color_from_string(text_color)
        canvas.fill_color(text_color) if text_color
        if canvas.font
          canvase_font_name = canvas.font.wrapped_font.font_name
          canvas_font_size  = canvas.font_size
          canvas_fill_color = canvas.fill_color
          if font_name == canvase_font_name && size == canvas_font_size
          elsif font_name != canvase_font_name
            font_foleder  = "/Users/Shared/SoftwareLab/font_width"
            font_file     = font_foleder + "/#{font_name}.ttf"
            doc           = canvas.context.document
            font_wapper   = doc.fonts.add(font_file)
            canvas.font(font_wapper, size: size)
          elsif size != canvas_font_size
            canvas.font(canvas.font, size: size)
          else
            font_foleder  = "/Users/Shared/SoftwareLab/font_width"
            font_file     = font_foleder + "/#{font_name}.ttf"
            doc           = canvas.context.document
            font_wapper   = doc.fonts.add(font_file)
            canvas.font(font_wapper, size: size)
          end
        else
          size = @para_style[:font_size] || 16
          font_foleder  = "/Users/Shared/SoftwareLab/font_width"
          font_file     = font_foleder + "/Shinmoon.ttf"
          font_file     = font_foleder + "/#{font_name}.ttf" if font_name
          doc           = canvas.context.document
          font_wapper   = doc.fonts.add(font_file)
          canvas.font(font_wapper, size: size)
        end

        f = flipped_origin
        x_offset = f[0]
        y_offset = f[1]
        canvas.text(@string, at: [x_offset, y_offset - size])
      end
    end
  
  end

end

