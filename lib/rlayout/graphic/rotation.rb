
# With rotation: we rotate at the center point
# With rotate_content: we rotate content only

module RLayout
  
  class Graphic
    attr_accessor :rotation, :rotate_content
    
    def init_rotation(options)
      @rotation         = options[:rotation]  if options[:rotation]
      @rotation         = options[:rotate]  if options[:rotate]
      @rotate_content   = options[:rotate_content]    if options[:rotate_content]
    end
  end
  
  
  
end