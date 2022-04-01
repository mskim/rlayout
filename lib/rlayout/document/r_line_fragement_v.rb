module RLayout

  class RLineFragmentV < RLineFragmentV
    attr_accessor :v_x, :v_y, :v_width, :v_height

    def initialize(options={})
      super


      self
    end

    def place_token(token, options={})
      puts __method__
    end

    def align_tokens
      puts __method__
    end

    def draw_pdf(canvas, options={})
      
    end

  end


end