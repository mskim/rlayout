
# data_folder
#    data.csv
#    images
# cell_template
# layout.erb
# layout.rb is generated
# output.pdf is generated
# output.pdf is moved to images as 1.pdf, 2.pdf

# images

module RLayout
	class ObjectBox < ImageBox
	  attr_accessor :cell_type, :data_path, :template_path
	  def initialize(parent_graphic, options={})
	    @image_group_path = options.fetch(:image_group_path, "#{$ProjectPath}/images")
	    @template_path    = "#{$ProjectPath}/template"
	    @data_path        = "#{$ProjectPath}/data"
	    unless File.exist?(@data_path)
	      puts "No data_path exists!!!"
	      return
	    end
	    unless File.exist?(@template_path)
	      puts "No template_path exists!!!"
	      return
	    end
	    generate_cell_images
	    super
	        
	    
	    
	    
	    self
	  end
	  
	  def generate_cell_images
	    
	  end
	  
	end

end