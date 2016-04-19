
# GrowingContainer

# bottom or right position is fixed but height or width can grow
# 1. it grows to the top or left
# 1. it has anchor marks, from_bottom, from_right
# 1. it can other objects, such as Image

module RLayout
  
  class GrowingContainer < Container
    attr_accessor :growing_direction # "top", "left"
    attr_accessor :from_bottom, :from_right  
    
    def initialize(options={}, &block)
      @growing_direction = "top"
      
      self
    end
  
    def set_content!
      
    end
  end
  
end