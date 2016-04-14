
# Dorok
# Dorik is Koren name for art collection picture book.
# This program is used to automate the process of creating Dorok.

# Dorok can be crated in several ways.
# First and most intuitive way is to creaete folders that are represeting the pages.
# And placing corresposing pictures in that folder, and let this program automate the process

# Another way is to use Excel or csv to even automate the first process.
# For this case, we need images on the designated place, like online image storage.
# Page folders can be created from csv file and images can be placed automaticall.

# Each page folders contain, images, layout, and text.md
# Layouts are auto selected from the templates. 
# Layouts are auto selected by profile.
# Profile is detmined by the number of pictures in the images folder, and number of text.md files.
# Several layouts, with same profile, are pulled from the library, to allows us to present several options.

# PhotoPage
# Each page is layed out and PDF is generated

# Web Interface
# Resultinng pages are shown using web interface
# User can select final page from several layout choices. 

module RLayout
  class Dorok
    attr_accessor :path, :image_files, :template, :style, :page_folders
	  def initialize(path, options={})
	    @path     = path
	    @template = options[:template]
      create_pages_folders_from_csv
      @page_folders.each do |page_path|
        setup_page_folders(page_path)
      end
      # save_pdf(@path + "/photobook.pdf")
	    self
	  end
    
    def create_pages_folders_from_csv
      @page_folders = []
      
    end
    
    def setup_page_folders(page_path)
      DorokPage.new(page_path)
    end
    
    def create_rakefile
    end
  end

  # Dorok
  class DorokPage
	  attr_accessor :page_path, :profile, :template_path, :image_files, :templates
    def initialize(page_path, options={})
      unless File.exist?(page_path)
        puts "File #{page_path} doesn't exit!!!!"
        return
      end
      @page_path      = page_path
      @template_path  = options.fetch(:template_path, "/Users/Shared/SoftwareLab/dorok")
      get_templates
      # move_images_to_images_folder
      generate_pdf
      self
    end
    
    def parse_image_files
      Dir.glob("#{@page_path}/images/*{.jpg, .tiff]}").each do |file|
        @image_files << file
      end
    end
    
    def get_templates
      @image_files    = []
      @templates      = []
      parse_image_files
      profile = @image_files.length.to_s
      @templates = Dir.glob("#{@template_path}/#{profile}*")
    end
    
    
    def generate_pdf
      @image_files.each_with_index do |image_path, i|
        instance_eval("@image#{i+1} = \"#{File.basename(image_path)}\"")
      end      
      @templates.each_with_index do |template, i|
        generate_pdf_for(template, i+1)
      end
    end
    
    # move images to images folder
    def move_images_to_images_folder
      images_folder = @page_path + "/images"
      unless File.directory?(images_folder)
        system("mkdir -p #{images_folder}")
      end
      @image_files.each do |file|
        system("mv #{file} #{images_folder}/")
      end
    end
    
    # generate layout.rb from template
    def generate_pdf_for(template_file, layout_index)   
      template = File.open(template_file, 'r'){|f| f.read}
      erb = ::ERB.new(template)
      layout = erb.result(binding)
      layout_path = @page_path + "/layout-#{layout_index}.rb"
      output_path = @page_path + "/#{layout_index}.pdf"
      File.open(layout_path, 'w'){|f| f.write layout}
      system("/Applications/rjob.app/Contents/MacOS/rjob #{@page_path} #{layout_path} #{output_path} -jpg")
    end
    
  end

end
