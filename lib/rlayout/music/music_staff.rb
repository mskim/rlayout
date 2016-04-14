
# [ 
#   [:clef_g, :four_four, [c1,d1,e1,f2,g2, :lylic=>"This is some" ], [c1,d1,e1,f2,g2 ], [c1,d1,e1,f2,g2 ], [c1,d1,e1,f2,g2 ]]
#   []
# ]
module RLayout
  class GrandStaff
    
    
  end
  
  class Staff
    attr_accessor :measures
    
    def initialize(options={})
      
      
      self
    end
  end
  
  class Measure
    attr_accessor :clef, :notes, :lylic, :code, :dynamics
    attr_accessor :upper_elements, :connecting_bars, :ties, :slurs
    def initialize(options={})
      
    end
  end
  
  class Note
    attr_accessor :pitch, :duration, :connecti_left, :connecti_right
    attr_accessor :accidental, :articulation, :accent
  end
  
  
  class Dynamics
    attr_accessor :kind, :location
    
  end
  
end