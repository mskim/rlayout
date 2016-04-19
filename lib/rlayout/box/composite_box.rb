
# CompositeBox is made up of compositing element.
# Each composite elements generates PDF files.
# CompositeBox assembles those elements into single PDF page.

module RLayout
  class CompositeBox < Container
    attr_accessor :profile
    def initialize(options={})
      super
      @profile = options[:profile]
      
      self
    end
    
    def layout_composite_box(options={})
      
    end
    
    def change_layout(new_profile)
      
    end
      
  end
  
  
end