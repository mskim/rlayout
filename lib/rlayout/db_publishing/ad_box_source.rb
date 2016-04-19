
module RLayout
  
  class AdBox < Container
    attr_accessor :company, :phone, :coyp1, :copy2, :image_path
    attr_accessor :template, :ad_box
    def initialize(options={}, &block)
      super
      @klass = "AdBox"
      @template = options[:template]
      @company  = options[:company]
      @phone  = options[:phone]
      @coyp1  = options[:coyp1]
      @coyp2  = options[:coyp2]
      @image_path  = options[:image_path]
      layout_item
      self
    end
    
    def layout_ad_box
      
    end
    
    def self.from_template(template, options={})
      ad_box = Container.new(template)
      ad_box.substibute_variables(options)
      ad_box
    end
    
    def self.samples_of(number)
      ad = []
      number.times do
        ad << self.sample
      end
      ad
    end
    
    def self.sample
      ad = AdBox.new(line_width: 2, line_color: 'gray') do
        @company = text(text_string: ramdom_text, fill_color: random_color, line_with: 2, line_color: 'red')
        @phone   = text(text_string: ramdom_text, fill_color: random_color)
        @copy1   = text(text_string: ramdom_text, fill_color: random_color, line_with: 2, line_color: 'red')
        @copy2   = text(text_string: ramdom_text, fill_color: random_color, line_with: 2, line_color: 'red')
      end
      ad.relayout!
      ad
    end
        
    def layout_content(room)
      
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

