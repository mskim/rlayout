
module RLayout
  
  ##
  
  class IdGraphic 
    attr_accessor :element
    def initialize(element, options={})
      @element =  element
      self
    end
  end
  
  class IdPage < IdGraphic
    def initialize(xml, options={})
      super
      self
    end  
  end
  
  class IdTextFrame < IdGraphic
    def initialize(xml, options={})
      super
      self
    end  
    
  end
  
end