module RLayout
  # RForm
  # place holder for form
  # table like where cell 

  # fields
  # frame_rect, style_name
  class RForm < Container
    attr_accessor :grid_base, :cells
    attr_reader :fields
    def initialize(options={})
      @fields = options[:fields]
      
      self
    end

  end

end