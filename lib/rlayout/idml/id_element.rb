
module RLayout
  
  ##
  class IdElement 
    attr_accessor :element
    def initialize(element, options={})
      @element =  element
      self
    end
  end
  
  class IdPage < IdElement
    def initialize(xml, options={})
      super
      self
    end  
    
    def page_layout_text
      page_content = <<-EOF
    # some more page contnet  
              
      EOF
      text = <<-EOF
  page do
#{page_content}
          
  end
      
EOF
    end
  end
  
  class IdTextFrame < IdElement
    def initialize(xml, options={})
      super
      self
    end  
    
  end
  
end