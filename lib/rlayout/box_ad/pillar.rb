module RLayout
  class Pillar < Container

    attr_reader :profile
    def initialize(options={})
      @layout_direction = 'horizontal'
    end

    def add_item
      # add stack
    end
  end

  class Stack < Container
    def initialize(options={})

    end

    def add_item
      # add item at the bottom of the stack

    end
  end

end