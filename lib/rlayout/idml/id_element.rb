
module RLayout
  
  ##  
  class IdPage < XMLElement
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
  
  class IdTextFrame < XMLElement
    def initialize(xml, options={})
      super
      self
    end  
    
  end
  
end