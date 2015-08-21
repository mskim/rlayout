
module RLayout
    
  class PDFDoc
    attr_accessor :path, :pages
    
    
    def to_hash
      
    end
  end
  
  class PDFPage
    attr_accessor :graphic_stack, :operations
    
    def initialize(doc, operations)
      @doc            = doc
      @operations     = operations
      @graphic_stack  = []
      parse_operations
      self
    end
    
    def parse_operations
      
    end
    
    def to_hash
      
    end
  end
  
  class PDFGraphic
    attr_accessor :stroke, :fill, :font
    
    
  end
  
  class PDFPath < PDFGraphic
    
    def to_hash
      
    end
  end
  
  class PDFText < PDFGraphic
    def to_hash
      
    end
  end
  
  class PDFImage < PDFGraphic
    
    def to_hash
      
    end
    
  end
end