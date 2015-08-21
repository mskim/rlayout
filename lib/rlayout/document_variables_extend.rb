
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
      elsif options[:varaiables_hash]
        @keys = options[:varaiables_hash].keys
        @data = options[:varaiables_hash].values
      end
      if options[:project_path]
        @project_path = options[:project_path] 
      else
        @project_path = File.dirname(File.dirname(options[:output_path]))
      end
      document = nil
      if options[:template_hash]
        document = Document.new(options[:template_hash])
        document.pages.each do |page|
          page.keys = @keys
          page.data = @data
          page.replace_tagged_graphic
          page.replace_image
        end
      elsif options[:template_document]
        document = options[:template_document]
        document.pages.each do |page|
          page.keys = @keys
          page.data = @data
          page.replace_tagged_graphic
          page.replace_image
        end        
      end
      
      page = document.pages.first
      # puts "page.graphics.length:#{page.graphics.length}"
      # puts "page.graphics.first.class:#{page.graphics.first.class}"
      # puts "page.graphics.first.x:#{page.graphics.first.x}"
      # puts "page.graphics.first.y:#{page.graphics.first.y}"
      # puts "page.graphics.first.width:#{page.graphics.first.width}"
      # puts "page.graphics.first.height:#{page.graphics.first.height}"
      
      if page.graphics.first.class == RLayout::Image
        puts "image........"
        puts "page.graphics.first.image_path:#{page.graphics.first.image_path}"
      end
      # template = options[:template_hash].dup
      # pages = []
      # template[:pages].each do |page_hash|
      #   options[:template_hash] = page_hash
      #   options[:keys] = @keys
      #   options[:data] = @data
      #   options[:for_variable_document] = true
      #   # pages << Page.variable_page(options)
      #   Page.new(document, Page.variable_page(options))
      # end  
      # document.pages = []
      # document.add_page(pages)
      # puts "after document.pages.length:#{document.pages.length}"
      
      puts "options[:output_path]:#{options[:output_path]}"
      if options[:output_path]
        document.save_pdf(options[:output_path])
      end
      document
    end
        
    # batch process with template and csv file 
    def self.batch_variable_documents(options={})
      template_hash = nil
      template_document = nil
      if options[:template_path]
        template_hash = YAML::load_file(options[:template_path])
      elsif options[:template_hash]
        template_hash = options[:template_hash]
      elsif options[:template_document]
        template_document = options[:template_document]
        first_page = template_document.pages.first
        first = first_page.graphics.first
        puts "first.class:#{first.class}"
        if first.class == RLayout::Image
          puts "first.image_path:#{first.image_path}"
        end
      end
      # we should have template_hash or template_path option to process
      # unless template_hash
      unless template_document
        puts "No template!!!"
        return 
      end
      
      csv_path = options[:csv_path]     if options[:csv_path]
      unless File.exists?(csv_path)
        puts "No csv_path!!!"
        return 
      end
      
      @output_folder=File.dirname(csv_path) + "/pdf"
      @output_folder=options[:output_folder] if options[:output_folder]
      system("mkdir -p #{@output_folder}") unless File.exists?(@output_folder)
      rows= Page.parse_csv(csv_path)
      keys=rows[0]
      # documents = []
      rows.each_with_index do |row_data, index|
        next if index==0
        next unless row_data[0] # preventive in case the name field is empty
        name = row_data[0]
        name.gsub!(" ","")
        name.gsub!("(","_")
        name.gsub!(")","_")
        output_path =@output_folder + "/#{name}.pdf"
        Document.variable_document(:template_document=>template_document.dup, :output_path=>output_path, :keys=>keys, :data=>row_data)  
        
        # documents << Document.variable_document(:template_hash=>template_hash, :output_path=>output_path, :keys=>keys, :data=>row_data)  
      end
      # documents
    end
        
  end

end


