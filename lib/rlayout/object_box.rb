module RLayout
  
  # ObjectBox is general pulpose container of flowing objexts.
  # When Text paragraphs flow, it acts as traditional TextBox.
  # ObjectBox is a general purpose container handling other types of objects as well.
  # Product items, BoxAds, Directory elements, quiz items or any other objects shoud be able to flow, 

  # ObjectBox contains Columns. Objects are layed out along columns.
  # ObjectBox can be linek to other ObjectBox, "next_link" and "previous_link" points to them.
  
  
  class ObjectBox < Container
    attr_accessor :column_count, :next_link, :previous_link
    
    def initialize(parent_graphic, options={}, &block)
      super
      @layout_direction  = options.fetch(:layout_direction, "horizontal")
      @layout_space  = options.fetch(:layout_space, 10)
      @column_count = options.fetch(:column_count, 3)
      create_columns
      if block
        instance_eval(&block)
      end
      self
    end
    
    def create_columns
      @column_count.times do
        ColumnObject.new(self)
      end
      relayout!
    end
    
    # layout_items is used for batch layout
    # steps
    # 1. Ask each flowing objects to adjust their width to column width.
    # 2. Each flowing objects changes their width and their height.
    # 3. Take group of flowing items by their height sum
    # 4. Place them in the column
    # 5. And go on to the next column
    
    def layout_items(flowing_items, starting_index=0)
      column_index = 0
      current_column = @graphics[column_index]
      flowing_items.each {|item| item.change_width(current_column.layout_area[0])}
      
      while front_most_item = flowing_items.shift do
        if current_column.push_item(front_most_item)
          
        else
          column_index += 1
          puts "+++++ column_index:#{column_index}"
          current_column = @graphics[column_index]
          if column_index == @column_count
            # we have done for this ObjectBox
            if @next_link
              @next_link.layout_flowing_objects(flowing_items)
            else
              puts "+++++ overflow in this box"
              return false
            end
          else
            # TODO what if this fails
            # This is the case where the item does not if even if this is the new empty column
            current_column.push_item(front_most_item)
            # should go to next or force?
          end
        end
      end
        
    end
    
    
    #TODO
    ####### interactive mode ##########
    def insert_item_at(item, column_index, index)
      # insert an item at 
    end
    
    def delete_item
    end
    
    def delete_item_at(column_index, index)
    end
  end
  
  class ColumnObject < Container
    attr_accessor :current_position
    def initialize(parent_graphic, options={}, &block)
      super
      @current_position = @top_margin + @top_inset
      
      if block
        instance_eval(&block)
      end
      self
    end
    
    def push_item(item)
      puts __method__
      puts item
      if (item.height + @layout_space + @current_position) <= @height
        # insert item
        item.parent_graphic = self
        item.y = @current_position
        item.x = @left_margin + @left_inset
        @graphics << item
        puts "@graphics.length:#{@graphics.length}"
        @current_position += item.height + @layout_space
        true
      else
        # cant't insert 
        false
      end
    end
  end
  
  # Paragraph, CatalogItem, Address, or quiz item are typical FlowingObject.
  # FlowingObject can be allowed to be broken into parts, for better fit into column.
  # Sometime FlowingObject can not be broken, so "breakable" variable tells, whether they can be broken.
  # ex. Text Paragraph can be broken into parts, but product box may not.
  class Paragraph < Container
    attr_accessor :breakable, :part # head, body, tail
    attr_accessor :markup, :text_string
    
    def change_width(new_width)
      @width = new_width
      # TODO
      # change height we need to
    end
    def to_svg
      if @parent_graphic
        return svg
      else
        svg_string = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n"
        svg_string += svg
        svg_string += "</svg>\n"
        return svg_string
      end
    end
    
    def svg
        s = "<rect x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{@height}\""
        if @fill_color!=nil && @fill_color != ""
          s+= " fill=\"#{@fill_color}\""
        end
        if @line_width!=nil && @line_width > 0
          s+= " stroke=\"#{@line_color}\""
          s+= " stroke-width=\"#{@line_width}\""
        end
        s+= "></rect>\n"
        
        if @text_string !=nil && @text_string != ""
          s += "<text font-size=\"#{@text_size}\" x=\"#{@x}\" y=\"#{@y}\" fill=\"#{@text_color}\">#{@text_string}</text>\n"
        end
        s
    end
    
    def self.generate(number)
      list = []
      number.times do
        list << Paragraph.new(nil, fill_color: "gray")
      end
      list
    end
  end
  
  class CatalogItem < Container
    attr_accessor :breakable, :part # head, body, tail
    
    def change_width(new_width)
      @width = new_width
      # change height we need to
    end
  end
end