
module RLayout
  
  class XMLDocument
    attr_accessor :element
    def initialize(xml_text, options={})
      @element   = REXML::Document.new(xml_text)
    end
  end
  
  class XMLElement
    attr_accessor :element
    def initialize(element, options={})
      @element =  element
      self
    end    
  end
  
  class XMLPkgDocument
    def initialize(xml_text, options={})
      # super 
      package   = REXML::Document.new(xml_text)
      @element  = package.root.elements.first  if package.root.elements
      self
    end    
  end
  #   
  # 
  
  
  
end