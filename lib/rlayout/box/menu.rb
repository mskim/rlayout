module RLayout
  
  class Menu < Container
    attr_accessor :column_count, :menu_text, :menu_text_path
    def initialize(parent_graphic, options={})
      super
      if options[:menu_text_path]
        unless File.exist?(options[:menu_text_path])
          puts "menu_text: #{options[:menu_text_path]} doesn't exist!!!"
        end
        @menu_text = File.open(options[:menu_text_path], 'r'){|f| f.read}
      elsif options[:menu_text]
        @menu_text = options[:menu_text]
      else
        puts "No menu_text!!!"
      end
      rows = menu_text.split("\n")
      @item_rows = []
      rows.each do |row_text|
        @graphics << LeaderRow.new(nil, row_text:row_text)
      end
      self
    end
  end
    
  # fills the box with leader_character at run time
  class LeaderCell < Text
    attr_accessor :leader_character, :is_leader
    
    def initialize(parent_graphic, options={})
      options[:text_size] = parent_graphic.height - 4
      options[:height] = parent_graphic.height - 2
      super
      @is_leader = options.fetch(:is_leader, false)
      @leader_character = options.fetch(:leader_character, ".")
      self
    end
    
    # adjust_cell_size by adjusting text font size and width according to given cell_height
    def adjust_cell_size(cell_height)
      puts __method__
    end
  end
  
  # similar to TableRow, but has leader cell between text cell
  # Used for TOC, Menu, Jubo
  class LeaderRow < Container
    attr_accessor :row_text
    def initialize(parent_graphic, options={}, &block)
      options[:height] = 16 unless options[:height]
      options[:layout_expand] = [:width]
      options[:layout_direction] = "horizontal"
      super
      @row_text = options[:row_text]
      create_cells
      relayout!
      self
    end
    
    def is_breakable?
      false
    end
    
    def create_cells
      cell_text = @row_text.split(",")
      cell_text.each_with_index do |text_string, i|
        LeaderCell.new(self, text_string:text_string)
        LeaderCell.new(self, is_leader:true) unless i >= cell_text.length - 1
      end
    end
    
    def relayout!
      cell_height         = @height - 2
      text_cells          = @graphics.select{|cell| cell.is_leader!=true}
      text_cells.each do |cell|
        cell.adjust_cell_size(cell_height)
      end
      text_cell_width_sum = text_cells.map{|cell| cell.width}.reduce(:+)
      leader_cells        = @graphics.select{|cell| cell.is_leader==true}
      space_for_leader    = (@width - text_cell_width_sum)/leader_cells.length
      leader_cells.each {|cell| cell.width = space_for_leader}
      x= 0
      @graphics.each do |cell|
        cell.x      = x
        cell.y      = 1
        cell.height = cell_height
        x += cell.width
      end
    end
  end
end