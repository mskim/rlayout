module RLayout

	class GSqrt < Container
	  attr_accessor :root_left, :root_top, :body
	  
	end
	
	class GDivide < Container
	  attr_accessor :nominator, :denominator, :divider_line
	  
	end
	
	class GLimit < Container
	  attr_accessor :left, :upper, :lower, :body
	  
	end
	
	class GSum < Container
	  attr_accessor :left, :upper, :lower, :body
	
	end
	
  class GEqual < Container
	  attr_accessor :left, :right, :lower
  end
  
  class MathCell < Container
    
    def self.parse(text)
      
    end
  end
  
	class MathLine < Container
	  
	end
  
  class MathBlock < Container
    
  end
	

end