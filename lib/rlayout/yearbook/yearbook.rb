module RLayout

  # Yearbook
  # Yearbook looks for "book_plan.yml" file 
  # 1. Generate folder structure from book_plan.yml
  # 1. Copy design layout from design_template by section(category)
  # 1. Layout each section
  # 1. Generate TOC
  # 1. Generate Index
  # 1. Combine into single PDF book
  # 1. Create static website 
  # 1. Create imposition for print.

  # section
  # section is a section of book, consisting of single section. It can be a single page or multiple page.
  # 
  # design_template for section
  # desing template for section consists of layour.rb, text_style,yml, and sample content
  #
  # sample content
  #   bg_image.jpg, story.md, images, tables


  class Yearbook
    attr_reader :category, :school, :year, :project_path
    attr_reader :template_path, :page_size
    attr_reader :book_plan, :class_count

    def initialize(project_path, options={})
      @project_path  = project_path
      @design_path   = options[:design_path] || default_design_path
      @page_size     = options[:page_size] || "A4"
      @class_count   = options[:class_count] || 8
      create_section_folders
      copy_design
      build_sections
      self
    end

    def default_design_path
      "/Users/Shared/SoftwareLab/yearbook"
    end

    def default_yearboo_plan
      sections = %w[전경 교가 교장 선생님 학급_3-1 학급_3-2 학급_3-3 학급_3-4 학급_3-5 학급_3-6 학급_3-7 학급_3-8 수학여행 운동회 동아리 편집후기]
      plan = {}
      plan[:category] = "고등학교"
      plan[:school] = "낙생고등학교"
      plan[:year] = '2021'
      plan[:sections] = sections
      plan
    end

    def create_section_folders
      @book_plan = read_book_plan
      year = @book_plan[:year]
      school = @book_plan[:school]
      @book_plan[:sections].each_with_index do |section, i|
        section_path = @project_path + "/#{i + 1}_#{section}"
        FileUtils.mkdir_p(section_path) unless File.exist?(section_path)
      end
    end
    # merge each page PDF files into a book
    def merge_pdf_into_book

    end


    def book_plan_path
      @project_path + "/book_plan.yml"
    end

    def read_book_plan
      @book_plan = nil
      unless File.exist?(book_plan_path)
        @book_plan  = default_yearboo_plan
        File.open(book_plan_path, 'w'){|f| f.write @book_plan.to_yaml}
      else
        @book_plan      = YAML::load_file(book_plan_path)
      end
      @category = @book_plan[:category]
      @book_plan
    end


    # copy section design from desgn_template folder
    def copy_design(options={})
      @book_plan[:sections].each_with_index do |section, i|
        number_tag = "#{i + 1}"
        source = @design_path + "/#{@category}/#{section.split("_")[0]}"
        target = @project_path + "/#{number_tag}_#{section}"
        system("cp -r #{source}/ #{target}/")
      end
    end

    def build_sections
      @book_plan[:sections].each_with_index do |section, i|
        number_tag = "#{i + 1}"
        section_path = @project_path + "/#{number_tag}_#{section}"
        r = RLayout::Container.new(project_path: section_path)
        output_path = section_path + "/output.pdf"
        r.save_pdf(output_path)
      end
    end

    def build_book

    end
  end
  
end