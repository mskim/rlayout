
module RLayout
  
  class AdBox < Container
    def initialize(parent_graphic, options={})
      super
      @klass = "AdBox"
      
      self
    end
    
    def self.samples_of(number)
      ad = []
      number.times do
        ad << self.sample
      end
      ad
    end
    
    def self.sample
      ad = AdBox.new(nil) do
        rect(fill_color: random_color)
        rect(fill_color: random_color)
        rect(fill_color: random_color)
      end
      ad
    end
    
    def layout_text
      
    end
    
    def layout_text(room)
      
    end
    
    def is_linked?
      false
    end
  end
  
  # class AdBoxSource < DBSource
  #   
  #   def initialize
  #     super
  #     generate_ad
  #     self
  #   end
  #       
  # end  
end

