
module RLayout
  
  class AdBox < Container
    def initialize(parent_graphic, options={}, &block)
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
      # ad = AdBox.new(nil, line_width: 2, line_color: 'gray') do
      #   rect(fill_color: random_color, line_with: 2, line_color: 'red')
      #   rect(fill_color: random_color)
      #   rect(fill_color: random_color, line_with: 2, line_color: 'red')
      # end
      # ad.relayout!
      # ad
      AdBox.new(nil, fill_color: Graphic.random_color, line_width: 2, line_color: 'gray')
    end
    
    def layout_text
      
    end
    
    def layout_text(room)
      
    end
    
    def is_breakable?
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

