module RLayout

  # LeaderRow
  # table row with leading filler chars
  # LederRow has left middle right text and filling leader char in between
  # left ...... middle .......right
  # 찬송기 ........ 235 .......right

  # it is used in toc ,jubo, and munu 
  TextCell = TitleText
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
        TextCell.new(parent:self, cell_data:@row_data[0])
        LeaderCell.new(parent:self, cell_data:'.')
        TextCell.new(parent:self, cell_data:@row_data[1])
      elsif @row_data.length == 3
        TextCell.new(parent:self, cell_data:@row_data[0])
        LeaderCell.new(parent:self, cell_data:'.')
        TextCell.new(parent:self, cell_data:@row_data[1])
        LeaderCell.new(parent:self, cell_data:'.')
        TextCell.new(parent:self, cell_data:@row_data[2])
      end
      relayout!
    end
  end
end


