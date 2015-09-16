module RLayout

	class Frac < Container
	  attr_accessor :nominator, :denominator
	  
	end

	class Sqrt < Container
	  attr_accessor :root_left, :root_top, :body
	  
	end
	
	
	class Limit < Container
	  attr_accessor :left, :upper, :lower, :body
	  
	end
	
	class Sum < Container
	  attr_accessor :left, :upper, :lower, :body
	
	end
	
  class Equal < Container
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