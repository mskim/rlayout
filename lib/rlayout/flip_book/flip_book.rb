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
    
    def flipbook_data
      # FlipBook
      flip_book_data = []
      @book.front_matter.each do |front_matter|
        flip_book_data << [front_matter.kind, front_matter.preview_images]
      end
      @book.chapter.each do |chapter|
        flip_book_data << [chapter.title, chapter.preview_images]
      end
      @book.rear_matter.each do |rear_matter|
        flip_book_data << [rear_matter.kind, rear_matter.preview_images]
      end
      flip_book_data
    end
    
    def flip_book_index_html

    end
  end
  
end