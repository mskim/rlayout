

module RLayout
  
  class TableRow < Container
    attr_accessor :column_sytle_array, :column_alignment,:column_v_alignment, :column_text_color, :column_bgcolor
    
    def initialize(parent_graphic, options={})
      super
      if options[:options]
        @row_type = "head_row"
      else
        @row_type = "body_row"
      end
      @layout_direction   ='horizontal'
      @column_width_array     = parent_graphic.column_width_array
      @column_alignment = parent_graphic.column_alignment
      @column_v_alignment= parent_graphic.column_v_alignment
      @column_text_color= parent_graphic.column_text_color
      @column_bgcolor   = parent_graphic.column_bgcolor   
      create_row(options[:row_data], options)
      @auto_layout.space=0
      @auto_layout.padding=0
      self
    end
  end
  
  class Table < Container
    attr_accessor :prev_link, :next_link, :fit_type, :rows
    attr_accessor :head_row, :source, :title
    attr_accessor :column_width_array, :column_alignment_arrau,:column_v_alignment, :column_text_color, :column_bgcolor
    attr_accessor :header, :body, :source, :title
    attr_accessor :table_info
    
    def initialize(parent_graphic, options={}, &block)
      super
      @column_width_array     = options.fetch(:column_width_array, [1,1,1])
      @column_alignment = options.fetch(:column_alignment, %w[left left left])
      @column_v_alignment= options.fetch(:column_v_alignment, %w[top top top])
      @column_text_color= options.fetch(:column_text_color, %w[black black black])
      @column_bgcolor   = options.fetch(:column_bgcolor,  %w[white white white])
      @rows             = []
      @data             = options.fetch(:data,[])
      @head_row         = options.fetch(:head_row, false)
      @title            = options.fetch(:title, nil)
      @source           = options.fetch(:source, nil)
      create_rows(options)
      @auto_layout.space= 0
      @padding= 0
      relayout!
      self
    end
    
    def create_rows(options)
      @data.each_with_index do |row, i|
        if @head_row && i==1
          @graphics << TableRow.new(self, :row_data=>row, :head_row=>true)
        end
        @graphics << TableRow.new(self, :row_data=>row)
      end
    end
           
    def add_row(row_data)
      @graphics << TableRow.new(self, :row_data=>row_data)
    end
    
    def delete_row
      @graphics.pop
    end
    
    def insert_row_at(index, row_data)
      
    end
    
    #Todo need to check
    def delete_row_at(index)
      return if index < 0
      return if index > @graphics.length - 1 
      @graphics.delete(index)
    end
  end
end
