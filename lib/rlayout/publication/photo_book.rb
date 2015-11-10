
module RLayout
  
  class PhotoBook
    attr_accessor :path, :book, :source, :source_type, :template_path
    
    def initialize(source, options={})
      @source         = source
      @source_type    = options.fetch(:source_type, "not_grouped")
      @path           = options.fetch(:path, "/Users/mskim/photo_book/20-page-A4-Landscape")
      @template_path  = options.fetch(:template_path, @path + "/template")
      if @source_type == 'not_grouped'
        copy_images_to_book_folder
      else
        copy_image_groups_to_book_folder
      end
      layout_images
      merge_pdf
      impose_pdf
      move_done_job
      self
    end
    
    # When images are not grouped 
    # we check how many total images we have, images_count
    # look for template that is tayler made for images_count 
    # copy pre-made patters and replace image with our images
    def copy_images_to_book_folder
      images        = Dir.glob("#{source}/**.jpg")
      images_count  = images.length
      template      = @template_path + "/#{images_count}"
      @book_name    = File.basename(source)
      @book         = @path + "/jobs" + "/#{@book_name}"
      Dir.glob("#{template}/**") do |folder|
        if File.directory?(folder)
          page = @book + "/" + File.basename(folder)
          system("mkdir -p #{page}") unless File.exist?(page)
          Dir.glob("#{folder}/**") do |template_item|
            if template_item =~ /images/
              page_images = page + "/images"
              system("mkdir -p #{page_images}") unless File.exist?(page_images)
              # move image from source to page_images
              source_images = Dir.glob("#{@source}/*.{jpg,png}")
              i = 0
              Dir.glob("#{template_item}/*.{jpg, png}") do |template_images|
                image_name = File.basename(template_images)
                system("mv #{source_images[i]} #{page_images}/#{image_name}")
                i += 1
              end
            elsif template_item =~ /.pdf$/
              # do not copy pdf
            else
              # copy layout files and other
              system("cp #{template_item} #{page}/")
            end
          end          
        end
      end
      #copy Rakefile from template
      system("cp #{template}/Rakefile #{@book}/")
    end
    
    # When images are already grouped into a folder
    # with folder name as template
    def copy_image_groups_to_book_folder
      
      
      #copy Rakefile from template
      system("cp #{template}/Rakefile #{@book}/")
    end
    
    
    def layout_images
      system("cd #{@book} && rake")
    end
    
    def merge_pdf
      system("cd #{@book} && rake merge_pdf")
      system("mv #{@book}/book.pdf #{@path}/pdf/#{@book_name}.pdf")
    end
    
    def move_done_job
      done_folder = @path + "/jobs_done"
      system("mv #{@source} #{done_folder}/")
      #
    end
    
    def impose_pdf
      
      # after imposition, move pdf to done_do
      # done_folder = @path + "/jobs_done"
      # system("mv #{@path}/pdf/#{@book_name}.pdf #{done_folder}/")
    end
  end
  
end
