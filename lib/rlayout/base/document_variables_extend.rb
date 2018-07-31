# Processing variable images
# How do I process variable Images?
# Normally we use image_path, a full image path, for image.
# But when we handle variable document and design templates, this is not a good idea. 
# Since we do not know the full image path until the run time. We want relative path relative to 
# the project folder. 
# "project_folder" is the path to the project
# "tag" is the images folder, and "variable_name" is the name of the image file.  
# We use "tag" because we might have several image groups that are used in same project, 
# For example: we might have "pictures" folder for peoples picture and "barcode" for barcode images
# And in each folder, image files could be named with the person's name.
# If put them in one folder, we will have name conflict between pictire and barcode file name.
# So we we shoud use convention for image path in the form of "/project_path/tag/variable_name.jpg"

# What is local_image?
# local_image are used for images that are not variable, but relative to the project
# ,such as logos and background images.

module RLayout
  class Document
    attr_accessor :keys, :data, :project_path     
    def self.variable_document(options)
      if options[:keys] && options[:data]
        @keys = options.fetch(:keys, {})
        @data = options.fetch(:data, {})
      end
      if options[:project_path]
        @project_path = options[:project_path] 
      else
        @project_path = File.dirname(File.dirname(options[:output_path]))
      end
      document = options[:template_document]
      puts "document.class:#{document.class}"
      document.pages.each do |page|
        page.keys = @keys
        page.data = @data
        page.replace_tagged_graphic
        page.replace_image
      end
      
      if options[:output_path]
        document.save_pdf(options[:output_path])
      end
      document
    end
        
    # batch process with template and csv file 
    def self.batch_variable_documents(options={})
      project_path = options[:project_path]
      puts "project_path:#{project_path}"
      template_script_path = Dir.glob("#{project_path}/*.rb").first
      puts "template_script_path:#{template_script_path}"
      unless template_script_path
        puts "No template_script!!!"
        return 
      end
      csv_path = Dir.glob("#{project_path}/*.csv").first
      unless File.exists?(csv_path)
        puts "No csv_path!!!"
        return 
      end
      template_document  = eval(File.open(template_script_path,'r'){|f| f.read})
      if template_document.class == SyntaxError
        puts "eval SyntaxError creating template!!!"
        puts "template_document.inspect:#{template_document.inspect}"
        return
      end
      puts "template_document.class:#{template_document.class}"
      @output_folder= project_path + "/pdf"
      @output_folder=options[:output_folder] if options[:output_folder]
      system("mkdir -p #{@output_folder}") unless File.exists?(@output_folder)
      rows= Page.parse_csv(csv_path)
      keys=rows[0]
      rows.each_with_index do |row_data, index|
        next if index==0
        next unless row_data[0] # preventive in case the name field is empty
        name = row_data[0]
        name.gsub!(" ","")
        name.gsub!("(","_")
        name.gsub!(")","_")
        output_path =@output_folder + "/#{name}.pdf"
        Document.variable_document(:template_document=>template_document.dup, :output_path=>output_path, :keys=>keys, :data=>row_data)  
      end
    end
        
  end

end


