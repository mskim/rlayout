#TODO
# 1.force fit first column first item, when it doesn't fit 

module RLayout
  
  # ObjectBox is general pulpose container of flowing objexts.
  # ObjectBox contains Columns. Objects flow along columns. 
  # ObjectBox can be linek to other ObjectBox, "next_link" and "previous_link" points to them.
  # When Text paragraphs flow, it acts as traditional TextBox.
  # ObjectBox can handling other types of objects as well, 
  # Product items, BoxAds, Directory elements, quiz items or any other objects 
  # that supports flowing item protocol, namely "set_width_and_adjust_height"
  # one other flowing item protocol is :breakable?, whick tells the flowing item can be broken into parts.
  # ObjectBox has another layer called "floats"
  # floats sit on top layer and pushes out text content under neath
  # Typocal floats are Heading, Image, Quates, SideBox
   
  class ObjectBox < Container
    attr_accessor :column_count, :next_link, :previous_link
    attr_accessor :floats
    
    def initialize(parent_graphic, options={}, &block)
      super
      @layout_direction = options.fetch(:layout_direction, "horizontal")
      @layout_space     = options.fetch(:layout_space, 10)
      @column_count     = options.fetch(:column_count, 3)
      create_columns
      @floats           = options.fetch(:floats, [])
      if block
        instance_eval(&block)
      end
      
      @floats.each do |float|
        float.init_float
      end
      
      self
    end
    
    def create_columns
      @column_count.times do
        ColumnObject.new(self)
      end
      relayout!
    end
    
    # steps
    # 1. Ask each flowing objects to adjust their width to current_column width.
    # 2. Each flowing objects changes their width and their height.
    # 3. Place them in the column if it fits, 
    #    if it doen't fit, ask if we can break the item into parts.
    #    if they can be broken, try putting each parts until they all fit
    #    for the left over parts?
    #       go on to the next column and fit rest of the parts
    #       What if the next column can not fit all parts?
    
    def layout_items(flowing_items, starting_index=0)
      column_index = 0
      current_column = @graphics[column_index]
      
      # Adjusting width of flow item all at once is an option,
      # if we are sure that all column width are same
      # but, this could be ineffient if we have the varing width columns
      # flowing_items.each {|item| item.change_width_and_adjust_height(current_column.layout_area[0])}
      
      while front_most_item = flowing_items.shift do
        # change the width and height of item to place it in the current column, right before we place them
        # This way we can suppoert varing column widthed text_box
        front_most_item.change_width_and_adjust_height(current_column.layout_area[0]) if front_most_item.respond_to?(:change_width_and_adjust_height)
        if current_column.insert_item(front_most_item)
          # item fit into column successfully!
        else
          # puts "it does not fit this column!!"
          if front_most_item.respond_to?(:breakable?) && front_most_item.graphics.length > 0
            # puts "item is breakable into parts"
            front_most_item.graphics.each do |part|
              if current_column.insert_part(part)
                # part fits
              else
                # part doen not fit
                # relayout current column before going to the next
                current_column.relayout! 
                # go to next column
                column_index += 1
                if column_index == @column_count
                  if @next_link
                    @next_link.layout_flowing_objects(flowing_items)
                  else
                    # puts "+++++ overflow, we have no more link"
                    return false
                  end      
                end
                current_column = @graphics[column_index]
                if current_column.insert_part(part)
                else
                  # force fit
                  current_column.insert_part(part, :force_fit=>true)
                end
              end
            end
          else
            # puts "this is not breakable item"
          end
          
          current_column.relayout!
          column_index += 1
          current_column = @graphics[column_index]
          if column_index == @column_count
            # we are finished for this ObjectBox
            if @next_link
              @next_link.layout_flowing_objects(flowing_items)
            else
              # puts "+++++ overflow, we have no more link"
              return false
            end      
            
          else
            # This is the case where the item does not fit, even if this is the new empty column
            # For this case, force fit it into this column, since it is not going to fit anywhere.
            current_column.insert_item(front_most_item, :force_fit=>true)
          end
          
        end
      end
      # binding.pry
      
      
    end
    
    def link_to_next(flowing_items)
      if @next_link
        @next_link.layout_flowing_objects(flowing_items)
      else
        puts "+++++ overflow, we have no more link"
        return false
      end      
    end
    
    # insert array items into ObjectBox
    def insert_flowing_items_in_array(an_array, options={})
      even_column_height = options.fetch(:even_column_height, false)
      an_array.each do |item|
        result= insert_flowing_item(item)
        return result if !result
      end
      result
    end
    
    # insert flowing item to current object_box
    def insert_flowing_item(flowing_item) 
      result = false
      return false if @current_column_index >= @graphics.length
      
      if flowing_item.is_a?(Paragraph)
        flowing_item.set_width_and_update_height(current_column_content_width)
      end
      if flowing_item.respond_to?(:graphics) && flowing_item.graphics.length > 0
        flowing_item.graphics.each do |part|
          if insert_part_to_column(part)
            return true
          else  
            # return false #return rejected part
            return part #return rejected part
          end
        end
        return false
      else # flowing_item doesn't respond_to parts
        result = insert_item_to_column(flowing_item)
      end
      result
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
    attr_accessor :floats
    
    def initialize(parent_graphic, options={}, &block)
      super
      @layout_space = 10
      @current_position = @top_margin + @top_inset
      
      if block
        instance_eval(&block)
      end
      self
    end
    
    
    def insert_item(item, options={})
      if ((item.height + @layout_space + @current_position) <= @height) || (options[:fortce_fit]==true)
        # insert item
        item.parent_graphic = self
        item.y = @current_position
        # puts "@current_position:#{@current_position}"
        # puts "item.y:#{item.y}"
        # puts "item.class:#{item.class}"
        item.x = @left_margin + @left_inset
        @graphics << item
        @current_position += item.height + @layout_space
        true
      else
        # cant't insert 
        return false
      end
    end
    
    def insert_part(part, options={})
      # for now we just use insert_item
      # I might need to do something different when inserting parts?
      insert_item(part, options={})
    end
  end
  
end