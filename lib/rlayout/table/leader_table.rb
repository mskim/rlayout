module RLayout

  class LeaderTable < Table

  end


  # starting ........ middle ....... ending
  class LeaderRow < TableRow
    attr_reader :starting, :middle, :ending
    attr_reader :leader_character
    def initialize(options={})
      @layout_direction = 'horizontal'
      @starting = options[:starting]
      @middle   = options[:middle] if options[:middle]
      @ending   = options[:middle] if options[:middle]
      @leader_character = options[:leader_character] || "."
      create_table_cells
      relayout!
      self
    end

    def create_table_cells
      TableCell.new(parent:self, string: @starting, layout_expand:nil)
      if @middle
        LeaderCell.new(parent:self, leader_character: @leader_character, layout_expand:width) 
        TableCell.new(parent:self, string: @middle, layout_expand:width) 
        LeaderCell.new(parent:self, leader_character: @leader_character, layout_expand:width) 
      else
        LeaderCell.new(parent:self, leader_character: @leader_character, layout_expand:width) 
      end
      TableCell.new(parent:self, string: @starting, , layout_expand:nil)
      # adjust cell size
    end

  end

  class LeaderCell < TableCell
    # leader char
    attr_reader :leader_character
    attr_accessor :width

    def initialize(options={})
      @layout_expand = :width
      @leader_character = options[:leader_character]
      self
    end

    def draw_pdf(canvas)
      # draw leader_character

    end
  end

end