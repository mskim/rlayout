module RLayout

  class Paperback
    attr_reader :book_path, :sections
    def initialize(options={})
      @book_path = options[:book_path]
      unless @book_path
        puts "book_path not given!!!"
        return
      end
      @sections = options[:sections] || default_sections
      create_sections

      self
    end

    def default_sections
      %w[title_page prolog toc chapter_1 chapter_2 chapter_3 chapter_4]
    end

    def create_sections
      @sections.each_with_index do |section, i|
        folder_name = "#{i + 1}_#{section}"
        section_path = @book_path + "/#{folder_name}"
        if !File.exists?(section_path)
          FileUtils.mkdir_p(section_path) 
          copy_sample_content(folder_name)
        end
      end
    end

    def copy_sample_content(section_path)
      
    end

    def sample_page_hash
      h= {}
      h[1] = sample_image_hash
      h
    end

    def sample_image_hash
      h= {}
      h[:position] = 3
      h[:column] = 2
      h[:row] = 2
      h
    end
  end
end