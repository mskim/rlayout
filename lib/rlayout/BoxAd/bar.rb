module RLayout

  class Bar < Container
    attr_reader :profile, :text_array, :attrs_array
    def initialize(options={})
      @layout_direction = 'horizontal'
      @text_array = options[:text_array]
      @attrs_array = options[:attrs_array]
    end

    def create_items
      h = {}
      h[:parent] = self
      @text_array.each_with_index do |t,i|
        
      end

    end

    def add_item
      # add text 
    end

    def item_count
      graphics.length
    end
  end



end