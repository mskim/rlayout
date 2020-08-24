# # profile
#   # layout_direction
#   # menu_column_count
#   # menu_item_count
#   # paper_size

# # title style

# # menu style
#   # item_color, item_font, item_size, item_alignment
#   # leader_color, leader_font, leader_size, leader_alignment
#   # price_color, price_font, price_size, price_alignment
#   # left_margin, right_margin


# module RLayout
  
#   class Menu < Container
#     attr_accessor :column_count, :menu_text, :menu_text_path
#     def initialize(options={})
#       super
#       if options[:menu_text_path]
#         unless File.exist?(options[:menu_text_path])
#           puts "menu_text: #{options[:menu_text_path]} doesn't exist!!!"
#         end
#         @menu_text = File.open(options[:menu_text_path], 'r'){|f| f.read}
#       elsif options[:menu_text]
#         @menu_text = options[:menu_text]
#       else
#         puts "No menu_text!!!"
#       end
#       rows = menu_text.split("\n")
#       @item_rows = []
#       rows.each do |row_text|
#         @graphics << LeaderRow.new(row_text:row_text)
#       end
#       self
#     end
    
#     def relayout!
#       super
#     end
#   end
    
  # similar to TableRow, but has leader cell between text cell
  # Used for TOC, Menu, Jubo
  # class LeaderRow < Container
  #   attr_accessor :row_text
  #   def initialize(options={}, &block)
  #     options[:height] = 24 unless options[:height]
  #     # options[:layout_expand] = [:width, :height]
  #     options[:layout_direction] = "horizontal"
  #     super
  #     @row_text = options[:row_text]
  #     create_cells
  #     self
  #   end
    
  #   def is_breakable?
  #     false
  #   end
    
  #   def create_cells
  #     cell_text = @row_text.split(",")
  #     cell_text.each_with_index do |text_string, i|
  #       if i == cell_text.length - 1
  #         # align right for price
  #         LeaderCell.new(:parent=>self, text_string:text_string, text_alignment: "right")
  #       else
  #         LeaderCell.new(:parent=>self, text_string:text_string)
  #       end
  #       LeaderCell.new(:parent=>self, is_leader:true) unless i >= cell_text.length - 1
  #     end
  #   end
    
  #   def relayout!      
  #     cell_height         = @height - 2
  #     text_cells          = @graphics.select{|cell| cell.is_leader!=true}
  #     text_cells.each do |cell|
  #       cell.adjust_cell_size(cell_height)
  #     end
  #     text_cell_width_sum = text_cells.map{|cell| cell.width}.reduce(:+)
  #     leader_cells        = @graphics.select{|cell| cell.is_leader==true}
  #     space_for_leader    = (@width - text_cell_width_sum)/leader_cells.length
  #     leader_cells.each {|cell| cell.width = space_for_leader}
  #     x= 0
  #     @graphics.each do |cell|
  #       y      = 1
  #       height = cell_height
  #       width = cell.width
  #       if cell.is_leader?
  #         width = space_for_leader 
  #         cell.set_leader_char(width)
  #       end
  #       cell.set_frame([x,y,width,height])
  #       x += cell.width
  #     end
      
  #   end
  # end

end
