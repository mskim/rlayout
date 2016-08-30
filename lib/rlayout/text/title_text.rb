# TitleText is used to handle pre-designed TitleText, 
# such as Chapter titles, section titles, 
# which we used use anchored graphics
# By using TitleText we can assign current style to use it for markup.
# title_text = {
#  h1: title_text_1
#  h2: title_text_2
#  h3: title_text_3
# }
# and call, set_title, set_image to set the new title and new image
# For more complex design, use Container graphics option 

module RLayout
  # Text with background Graphic
	class TitleText < Container
	  attr_accessor :text_object, :bg_color, :bg_image
	  def initialize(options={})
	    text_options  = options.delete(:text_options)
      image_options = options.delete(:image_options)
	    super
	    if image_options
        image_options[:parent] = self
	      image(image_options)
	    end
	    text_string = text_options.delete(:text_string)
	    text_options[:parent] = self
	    text_options[:fill_color] = "clear"
	    @text_object = text(text_string, text_options)
	    self
	  end
	end
	
	def set_title(title)
	  @text_object.set_text(title)
	end
	
	def set_image(options={})
	  if options[:image_path] || options[:image_path]
    else
      puts "no image_path given!!"
      return
    end
	  unless @image_object
	    options[:parent] = self
      image(options)
      return
	  end
	  
    if options[:image_path]
	    @image_object.set_image_path(options[:image_path])
    elsif options[:local_path]
	    @image_object.set_local_image(options[:local_path])
    end
	end
end