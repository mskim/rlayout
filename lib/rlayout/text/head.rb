module RLayout
  # Head is used for rich head
	class Head < Container
	  attr_accessor :text_object, :bg_color, :bg_image
	  def initialize(options={})
	    text_options = options.delete(:text_options)
	    super
	    text_string = text_options.delete(:text_string)
	    text_options[:parent] = self
	    text_options[:fill_color] = "clear"
	    @text_object = text(text_string, text_options)
	    self
	  end
	end

end