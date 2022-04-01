module RLayout
  class RTextTokenV < RTextToken
    attr_accessor :v_x, :v_y, :v_width, :v_height

    def initialize(options={})
      super
      set_token_dimention
      sel
    end

    def set_token_dimention
      # width and height

    end

    def draw(canvas)

    end
  end



end