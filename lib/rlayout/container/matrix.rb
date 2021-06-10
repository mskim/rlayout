module RLayout
  # Matrix 
  # GroupImage, GroupCaption,and MTable are subclassed from Matrix
  # Subclass implements layout_items and objects can fill the what ever content it wants to fill in the cell.
  # This makes things a lot easier than having rows. 
  # GroupImage: MatrixImageCell < ImagePlus, 
  # GroupCaption: MatrixTextCell < TextCell, 
  # MTable: MatrixTextCell < TextCell, 

  # MatrixCells have column_index, row_index, 
  # :x_span, :y_span
  class Matrix < Container
    attr_reader :column, :row
    attr_reader :cells, :cell_width, :cell_height, :gutter
    attr_reader :cell_position, :image_folder
    attr_reader :cell_type # image, text 

    # TODP: add gutter
    def initialize(options = {})
      super
      @column       = options[:column] || 2
      @row          = options[:row] || 2
      @gutter       = options[:row] || 10
      @cell_type    = options[:cell_type] || 'image'
      @image_folder = options[:image_folder] || File.dirname(__FILE__)
      @cell_width   = (@width - @left_margin - @left_inset - @right_margin - @right_inset - @gutter*(@column -1))/@column
      @cell_height  = (@height - @top_margin - @top_inset - @bottom_margin - @bottom_inset - @gutter*(@row -1))/@row
      layout_items
      self
    end

    def layout_items
      y = @top_margin + @top_inset
      cell_position = 1
      @row.times do |j|
        x = @left_margin + @left_inset
        @column.times do |i|
          if @cell_type == 'image'
            MatrixImageCell.new(parent:self, image_folder: @image_folder, x:x, y:y, width:@cell_width, height:@cell_height, cell_position: cell_position, column_index:i,  row_index: j)
          else
            MatrixTextCell.new(parent:self, image_folder: @image_folder, x:x, y:y, width:@cell_width, height:@cell_height, cell_position: cell_position, column_index:i,  row_index: j)
          end
          cell_position += 1
          x += @cell_width + @gutter
        end
        y += @cell_height + @gutter
      end
    end

    def cells_of_row(index)
      starting = index*@column
      ending = starting + @column
      @graphics[starting..ending]
    end

    def cells_of_column(index)
      cells = []
      @row.times do |i|
        cells << @graphics[i*@column + index]
      end
      cells
    end

    def first_cell
      @graphics.first
    end

    def last_cell
      @graphics.last
    end
    
  end

  # cell_position starts at 1 not 0
  # image cell looks for image nameed cell_position 1.jpg, 2.jpg etc ...
  class MatrixImageCell < ImagePlus
    attr_reader :cell_position, :column_index, :row_index
    attr_reader :x_span, :y_span
    attr_reader :image_folder
    def initialize(options = {})
      @cell_position = options[:cell_position]
      @column_index = options[:column_index]
      @row_index = options[:row_index]      
      @image_folder = options[:image_folder]
      image_path = @image_folder + "/#{@cell_position}.jpg"
      options[:image_path] = image_path
      options[:fill_color] = 'white'
      super
      self
    end
  end

  class MatrixTextCell < TextCell
    attr_reader :cell_position, :column_index, :row_index
    attr_reader :x_span, :y_span
    attr_reader :text_string
    def initialize(options = {})
      @cell_position = options[:cell_position]
      @column_index = options[:column_index]
      @row_index = options[:row_index]
      options[:text_string] = options[:text_string] || 'untitled'
      super
      self
    end
  end


end