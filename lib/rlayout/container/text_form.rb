# FormBox
# FormBox consists of TextFields
# TextField consists of labels and data

module RLayout
  class TextField < Container
    attr_accessor :label, :data_field, :data_layout_length
	  def initialize(parent_graphic,options={})
	    super
	    @layout_space         = 2
	    @line_width         = 2
	    @line_color         = 'red'
	    @layout_direction   ='horizontal'
	    @data_layout_length = options.fetch(:data_layout_length, 2)
	    @label              = Text.new(self, :text_string=>options[:key])
	    @data_field         = Text.new(self, :text_string=>options[:data], :layout_length=>@data_layout_length)
	    self
	  end
  end
  
	class TextForm < Container
	  attr_accessor :keys, :data
	  def initialize(parent_graphic, options={})
	    super
	    @keys = options[:keys] 
	    @data = options[:data] 
	    @keys.each_with_index do |key, i|
	      TextField.new(self, :key=>key, :data=>@data[i])
	    end
	    relayout!
	  end	
	end

end