module RLayout

  class Matrix < Container
    attr_reader :column, :row
    attr_reader :cells, :cell_width, :cell_height
    attr_reader :cell_position, :image_folder
    def initialize(options = {})
      super
      @column       = options[:column] || 2
      @row          = options[:row] || 2
      @image_folder = options[:image_folder] || File.dirname(__FILE__)
      @cell_width   = (@width - @left_margin - @left_inset - @right_margin - @right_inset)/@column
      @cell_heigth  = (@height - @top_margin - @top_inset - @bottom_margin - @bottom_inset)/@column
      @cell_presents= (1..(@column*@row)).to_a
      create_cells
      self
    end

    def create_cells
      y = @top_margin + @top_inset
      @row.times do |j|
        x = @left_margin + @left_inset
        @column.times do |i|
          if position = @cell_presents[j*i + 1]
            MatrixCell.new(parent:self, image_folder: @image_folder, x:x, y:y, width:width, height:height, position: position)
          end
          x += @cell_width
        end
        y += @cell_heigth
      end
    end
  end
  
  class MatrixCell < Image
    attr_reader :position, :x_span, :y_span
    attr_reader :image_folder
    def initialize(options = {})
      @position     = options[:position]
      @image_folder = options[:image_folder]
      image_path   = @image_folder + "/#{@position}.jpg"
      options[:image_path] = image_path
      super

      self
    end
  end


end