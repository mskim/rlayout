module RLayout

  # TextRun is series of character with same attributes.

  # Similar to CTRun
  # It uses CTLine to draw, not CTFrame

  class TextRun < Graphic
    attr_accessor :vertical_alignment

    def initialize(parent_graphic, options={})
      super


      self
    end


  end


end
