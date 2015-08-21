
module RLayout
  
  class NameCard    
    attr_accessor :folder_path, :csv_path
    def initialize(folder_path)
      unless File.exist?(folder_path)
        puts "Folder #{folder_path} does not exist!!!"
        return
      end
      @folder_path = folder_path
      @csv_path = @folder_path + "/data.csv"
      unless File.exist?(@csv_path)
        puts "Folder #{@csv_path} does not exist!!!"
        return
      end      
      layout      = File.open(@folder_path + "/layout.rb", 'r'){|f| f.read}
      template    = eval(layout)
      template.save_pdf(@folder_path + "/sample.pdf")
      first_page  = template.pages.first
      first = template.pages.first.graphics.first
      puts "in NameCard"
      puts "first.class:#{first.class}"
      if first.class == RLayout::Image
        puts "first.image_path:#{first.image_path}"
        puts "first.tag:#{first.tag}"
      end
            
      options     = {
        csv_path: @csv_path,
        # template_hash: template.to_hash,
        template_document: template,
        output_path: @folder_path + "/output",
      }
      # Document.batch_variable_documents(options)
      self
    end
  end
  
end