#TODO
# 1.force fit first column first item, when it doesn't fit 

module RLayout
  
  # ObjectBox is general pulpose container of flowing objexts.
  # ObjectBox has Columns. Objects flow along columns. 
  # ObjectBox can be linek to other ObjectBox, "next_link" and "previous_link" points to them.
  # When Text paragraphs flow, it acts as traditional TextBox.
  # ObjectBox handls other types of objects as well, such as 
  # product items, BoxAds, Directory elements, quiz items or any other graphic objects, 
  # that support flowing item protocol, namely "set_width_and_adjust_height"
  # one other flowing item protocol is :breakable?, whick tells whether the flowing item can be broken into parts.
  # ObjectBox adds another layer called "floats"
  # floats sit on top layer and pushes out text content underneath
  # Typocal floats are Heading, Image, Quates, SideBox
   
  class ObjectBox < Container
    attr_accessor :column_count, :next_link, :previous_link
    attr_accessor :floats
    
    def initialize(parent_graphic, options={}, &block)
      super
      @klass = "ObjectBox"   
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
    
    def toc_on?
      false
    end
    
    def is_toc_item?
      false
    end
    
    def document
      
    end
    
    def add_to_toc_list(item)
      if is_toc_item?(item)
        document.add_to_toc_list(item)
      end
    end
    # steps
    # 1. take out front_most_item from the array
    # 1. adjust their width to current_column width.
    # 1. each flowing objects changes their width and their height.
    # 1. place them in the column if it fits, 
    #    if it doen't fit, ask if we can break the item into parts.
    #    if they can be broken, try putting each parts until they all fit
    #    for the left over parts?
    #       go on to the next column and fit rest of the parts
    #       What if the next column can not fit all parts?
    # 1. if the last column is reached with un-placed item, place item back at the fornt of the array and return no
    # 
    def layout_items(flowing_items)
      column_index = 0
      current_column = @graphics[column_index]
      current_column.set_starting_position_at_non_overlapping_area
      while front_most_item = flowing_items.shift do
        # Adjusting width of flow item all at once is an option, if we are sure that all column width are same
        # but, we could have varing width columns
        # flowing_items.each {|item| item.change_width_and_adjust_height(current_column.layout_area[0])}
        # This way we can suppoert varing column widthed text_box
        front_most_item.change_width_and_adjust_height(current_column.layout_area[0]) if front_most_item.respond_to?(:change_width_and_adjust_height)
        if current_column.insert_item(front_most_item)
          add_to_toc_list(front_most_item) if toc_on?
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
                  # place back un-inserted part  in the front of the array
                  flowing_items.unshift(part)
                  return false
                    
                end
                current_column = @graphics[column_index]
                current_column.set_starting_position_at_non_overlapping_area
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
          current_column.set_starting_position_at_non_overlapping_area if current_column
          if column_index == @column_count
            # we are finished for this ObjectBox
            # place back un-inserted item  in the front of the array
            #TODO
            flowing_items.unshift(front_most_item)
            return false
            
          else
            # This is the case where the item does not fit, even if this is the new empty column
            # For this case, force fit it into this column, since it is not going to fit anywhere.
            current_column.insert_item(front_most_item, :force_fit=>true)
          end
          
        end
      end
      
      # all item is placed!!! return true
      true
      
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
      @klass = "ColumnObject"
      @layout_space = 10
      @current_position = @top_margin + @top_inset
      
      if block
        instance_eval(&block)
      end
      self
    end
    
    # set @current_pasotion as start of non-overlapping y
    def set_starting_position_at_non_overlapping_area
      rect = non_overlapping_frame
      @current_position = rect[1] + @top_margin + @top_inset      
    end
    
    def insert_item(item, options={})
      if ((item.height + @layout_space + @current_position) <= @height) || (options[:fortce_fit]==true)
        # insert item
        item.parent_graphic = self
        item.y = @current_position
        item.x = @left_margin + @left_inset
        # puts "item.frame_rect:#{item.frame_rect}"
        @graphics << item
        @current_position += item.height + @layout_space
        # @current_position = max_y(item.frame_rect) + @layout_space
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