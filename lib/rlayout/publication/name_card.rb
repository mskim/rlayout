
# create name_card folder for each organizations
# each folder should have following
# data.csv
# images
# layout.erb
# output/
# qr_code * if qr_code is used
# Rakefile

module RLayout
  
  class NameCard    
    attr_accessor :folder_path, :csv_path
    def initialize(folder_path)
      @folder_path = folder_path
      unless File.exist?(@folder_path)
        system("mkdir -p #{folder_path}")
      end
      copy_template
      self
    end
    
    def copy_template
      name_card_template = "/Users/Shared/SoftwareLab/namecard_template"
      system("cp -r #{name_card_template}/ #{@folder_path}/")
    end
    
  end
  
end