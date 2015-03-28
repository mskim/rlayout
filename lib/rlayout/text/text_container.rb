
module RLayout

  class TextContainer < Container
    attr_accessor :direction, :grid_lines

    def initialize(parent_graphic, options={})
      super
      grid_lines = []
      create_grid_lines

      self
    end

    def create_grid_lines

    end
  end
end
