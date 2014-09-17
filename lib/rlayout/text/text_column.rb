module RLayout
  
  class  TextColumn < ColumnObject
    attr_accessor :current_position
    def initialize(parent_graphic, options={}, &block)
      super



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