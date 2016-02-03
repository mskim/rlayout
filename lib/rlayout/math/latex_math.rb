
module RLayout
  
  class LatexMath
    
    attr_accessor :latex_string, :hash
    
    def initialize(latex_string, options={})
      @latex_string = latex_string      
      flatten_brace
      self
    end
    
    
  end
  
  
end