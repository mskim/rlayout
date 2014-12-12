require 'yaml'

module RLayout
  class Page
    attr_accessor :keys, :data     
    # process variable page with template hash and variavle data
    # replace variables of hash, and then create the object
    # this is different approach from previous one, 
    # where we were creating objects and then replaced variable elements in the object.
    def self.variable_page(options)
      # case 1 : options[:key] and options[:data] are passed
      # usually from parsed CSV
      if options[:keys] && options[:data]
        @keys = options.fetch(:keys, {})
        @data = options.fetch(:data, {})
      # case 2 : options[:varaiables_hash] are passed as options
      elsif options[:varaiables_hash]
        @keys = options[:varaiables_hash].keys
        @data = options[:varaiables_hash].values
      end
      project_path = File.dirname(File.dirname(options[:output_path]))
      project_path = options[:project_path] if options[:project_path]      
      template = options[:template_hash].dup
      replace_tagged_hash(template[:graphics])
      replace_image_hash(template[:graphics], project_path)
      if template[:pages]
        # TODO  
        # also handle when tempage is Document
      end
      page=Page.new(nil, template)      
      if options[:output_path]
        page.save_pdf(options[:output_path])
      end
      page
    end
        
    # batch process with template and csv file 
    def self.batch_variable_pages(options={})
      template_hash = nil
      if options[:template_path]
        template_hash = YAML::load_file(options[:template_path])
      else
        template_hash = options[:template_hash]
      end
      # we should have template_hash or template_path option to process
      unless template_hash
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
      rows.each_with_index do |row_data, index|
        next if index==0
        next unless row_data[0] # preventive in case the name field is empty
        name = row_data[0]
        name.gsub!(" ","")
        name.gsub!("(","_")
        name.gsub!(")","_")
        output_path =@output_folder + "/#{name}.pdf"
        Page.variable_page(:template_hash=>template_hash, :output_path=>output_path, :keys=>keys, :data=>row_data)  
      end
    end
        
    ##################  variable data replacing  ##################
    
    def self.replace_tagged_hash(graphics_hash_array)
      return unless @keys
      @keys.each_with_index do |key,index|
        graphics_hash_array.each do |target_graphic|
          if target_graphic[:tag] && target_graphic[:tag] == key.to_s
            target_graphic[:text_string] = @data[index]
          end
        end
      end
    end
        
    def self.replace_image_hash(graphics_hash_array, project_path)
      graphics_hash_array.each do |image_graphic|
        if image_graphic[:klass] == "Image" && image_graphic[:tag]
          tag=image_graphic[:tag]
          image_folder=project_path + "/#{tag}"
          images_path_without_extension=image_folder + "/#{@data[0]}"
          images_path_with_extension = nil
          IMAGE_TYPES.each do |type|
            if File.exists?(images_path_without_extension + ".#{type}")
              images_path_with_extension = images_path_without_extension + ".#{type}"
              break
            end
          end
          image_graphic[:image_path] = images_path_with_extension
        end
      end
    end
        
    # The first case
    # replace taged graphic with data
    def replace_tagged_graphic
      return unless @keys
      @keys.each_with_index do |key,index|
        graphics=graphics_with_tag(key.to_s) 
        graphics.each do |target_graphic|
          @data[index]
          target_graphic.replace_string(@data[index])
        end
      end
    end
    
    # The second case
    # replace {{key}} part of text with data
    def replace_variables
       variables_hash=Hash[@keys.zip @data]  # make hash form @keys, @data array
       @graphics.each do |graphic|
         graphic.replace_variables(variables_hash)
       end
    end
    
    # replace the image_box content with variable data
    # @project_path is used to find pictures, QRcodes, and other project related resources
    # replace_image:
    # Each replaced images has to have a tag, that provides information
    # Exaple image tag for QRCode
    # image_box will have following tag
    #   QRcode
    def replace_image
      images_boxes=images_with_tag
      images_boxes.each do |image_box|
        image_box.auto_layout.expand=nil if image_box.auto_layout
        tag=image_box.tag
        image_folder=File.dirname(@path) + "/#{tag}"
        if File.exists?(image_folder)
          images_path_without_extension=image_folder + "/#{@data[0]}"
          image_box.replace_image_content(images_path_without_extension)
        end
      end
    end
    
    def graphics_with_tag(searching_tag)
      taged_graphics_array=[]
      @graphics.each do |graphic|
        taged_graphics_array<< graphic if graphic.tag == searching_tag
        taged_graphics_array += graphic.graphics_with_tag(tag) if graphic.kind_of?(Container)
      end
      taged_graphics_array
    end
    
    def images_with_tag
      images_array=[]
      @graphics.each do |graphic|
        if graphic.kind_of?(Image) && !@tag.nil?
          images_array<<graphic
        elsif graphic.kind_of?(Container)
          images_array += graphic.images_with_tag
        end
      end
      images_array
    end
    
    def self.parse_csv(csv_path)
      require 'csv'
      unless File.exists?(csv_path)
        puts "#{csv_path} doesn't exist ..."
        return nil
      end
      
      rows=[]
      result = nil
      if csv_path =~/_mac.csv$/
        result = NSString.alloc.initWithContentsOfFile(csv_path, encoding:NSUTF8StringEncoding, error:nil)
      elsif csv_path =~/_pc.csv$/
        #Korean (Windows, DOS) -2147482590
        result = NSString.alloc.initWithContentsOfFile(csv_path, encoding:-2147482590, error:nil)
      else
        result = NSString.alloc.initWithContentsOfFile(csv_path, encoding:NSUTF8StringEncoding, error:nil)
      end
      
      if result  # if reading was successful
        rows = CSV.parse(result)
        rows.pop if rows.last.length == 0
        return rows
      else
        puts "could not open the file #{path}"
      end
      rows
    end
        
  end  
end


