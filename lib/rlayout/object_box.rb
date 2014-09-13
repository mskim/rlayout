module RLayout
  
  # ObjectBox is general pulpose container of flowing objexts.
  # ObjectBox contains Columns. Objects are layed out along columns.
  # When Text paragraphs flow, it acts as traditional TextBox.
  # ObjectBox can be linek to other ObjectBox, "next_link" and "previous_link" points to them.
  # ObjectBox can handling other types of objects as well, Product items, BoxAds, Directory elements, quiz items or any other objects shoud be able to flow, 

  
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
    
    # steps
    # 1. Ask each flowing objects to adjust their width to column width.
    # 2. Each flowing objects changes their width and their height.
    # 3. Place them in the column, if it doen't fit ask if we can break the item into parts.
    # 4. And go on to the next column
    
    def layout_items(flowing_items, starting_index=0)
      column_index = 0
      current_column = @graphics[column_index]
      
      # Adjusting width of flow item all at once is an option,
      # if we are sure that all column width are same
      # but, this could be ineffient if we have the varing width columns
      # flowing_items.each {|item| item.change_width(current_column.layout_area[0])}
      
      while front_most_item = flowing_items.shift do

        # change the width and height of item to place it in the current column, right before we place them
        # This way we can suppoert varing column widthed text_box
        front_most_item.change_width(current_column.layout_area[0])
        if current_column.insert_item(front_most_item)
          # item fit into column successfully!
        else
          if front_most_item.respond_to?(:breakable?)
            # TODO
            
          end
          current_column.relayout!
          column_index += 1
          current_column = @graphics[column_index]
          if column_index == @column_count
            # we are finished for this ObjectBox
            if @next_link
              @next_link.layout_flowing_objects(flowing_items)
            else
              puts "+++++ overflow, we have no more link"
              return false
            end
          else
            # TODO what if this fails
            # This is the case where the item does not fit even if this is the new empty column
            # For this case we have to force fit it into this column, since it is not going to fit anywhere.
            current_column.insert_item(front_most_item)
          end
          
        end
      end
      # binding.pry
      
      
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
      @layout_space = 10
      @current_position = @top_margin + @top_inset
      
      if block
        instance_eval(&block)
      end
      self
    end
    
    def insert_item(item)
      if (item.height + @layout_space + @current_position) <= @height
        # insert item
        item.parent_graphic = self
        item.y = @current_position
        item.x = @left_margin + @left_inset
        @graphics << item
        @current_position += item.height + @layout_space
        true
      else
        # cant't insert 
        false
      end
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