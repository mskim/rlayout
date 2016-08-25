module RLayout
  
  class FlipBook
    attr_accessor :project_path, :flipbook_path, :index_html

    def initialize(project_path, options={})
      @project_path   = options[:project_path]
      @flipbook_path  = @project_path + "/flipbook"
      copy_template(options)
      generate_flipbook
      self
    end
    
    def copy_template(options={})
      source = options.fetch(:template,"/Users/Shared/SoftwareLab/flipbook")
      if File.directory?(source)
        system("cp -r #{source}/ #{@flipbook_path}/")
      end
    end
    
    def generate_flipbook
      
    end
    
  end
  
end