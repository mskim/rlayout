module RLayout
  
  # Admonition is a text block with icon to get attention.
  # We have several types of admonition, NOTE, CAUTION, WARNING, TIP
  
	class Admonition < Container
	  attr_accessor :type, :icon_path, :text, :icon_column, :text_column
	  
	  def initialize(options={}, &block)
	    super
	    @icon_column   = Container.new(self)
	    @text_column   = TextColumn.new(:parent=>self, latyou_length: 6)
	    
	    @type         = options.fetch(:type, "note")
	    @icon_path    = options.fetch(:icon_path, "/Users/Shared/SoftwareLab/icon/#{@type}")
	    @text         = options.fetch(:text, "admonition text goes here")
	    
	    #TODO make text para_data?
	    # relayout!
	    self
	  end
	
	end

end