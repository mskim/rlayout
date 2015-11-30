# Labeled lists are useful when you need to include a description or supporting text for each item in a list. Each item in a labeled list consists of a term or phrase followed by:
# a separator (typically a double colon, ::)
# at least one space or endline
# the item’s content

# horizontal option

module RLayout
	class LabeledList < Container
	
	  attr_accessor :label, :list, :horizontal_layout
	  
	  def initialize(parent_graphic, options={}, &block)
	    super
	    if options[:horizontal_layout]
	      
      else
        
      end
	    self
	  end
	
	end


end