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


  class Yearbook < Book
    attr_reader :category, :school, :year

    def initialize(project_path, options={})

      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @title = @book_info[:title]
      @page_size = options['paper_size'] || 'A4'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @starting_page_number = 1
      create_book_cover
      @front_matter = FrontMatterYearbook.new(@project_path)
      @body_matter = BodyMatterYearbook.new(@project_path)
      @rear_matter = RearMatterYearbook.new(@project_path)
      generate_toc
      generate_pdf_for_print
      generate_pdf_book 
      generate_ebook unless options[:no_ebook]
      # push_to_git_repo if options[:push_to_git_repo]

      # @design_path   = options[:design_path] || default_design_path
      # @page_size     = options[:page_size] || "A4"
      # @class_count   = options[:class_count] || 8
      # create_section_folders
      # copy_design
      # build_sections
      self
    end

    def default_design_path
      "/Users/Shared/SoftwareLab/yearbook"
    end

    def sections_with_design_template
      a = %w[전경 교가 교장 선생님 학급_3-1 학급_3-2 학급_3-3 학급_3-4 학급_3-5 학급_3-6 학급_3-7 학급_3-8 수학여행 운동회 동아리 편집후기]
      template = []
      a.each do |section|
        template << [section,"default"]
      end
      template
    end


    def default_yearbook_plan
      plan = {}
      plan[:category] = "고등학교"
      plan[:school] = "낙생고등학교"
      plan[:year] = '2021'
      plan[:sections] = sections_with_design_template
      plan
    end

    def create_section_folders
      @book_plan = read_book_plan
      year = @book_plan[:year]
      school = @book_plan[:school]
      @book_plan[:sections].each_with_index do |section, i|
        section_path = @project_path + "/#{i + 1}_#{section[0]}"
        FileUtils.mkdir_p(section_path) unless File.exist?(section_path)
      end
    end

    def book_plan_path
      @project_path + "/book_plan.yml"
    end

    def read_book_plan
      @book_plan = nil
      unless File.exist?(book_plan_path)
        @book_plan  = default_yearbook_plan
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
        section_name = section[0]
        source = @design_path + "/#{@category}/#{section_name.split("_")[0]}"
        target = @project_path + "/#{number_tag}_#{section_name}"
        system("cp -r #{source}/ #{target}/")
      end
    end

    def build_sections
      @book_plan[:sections].each_with_index do |section, i|
        number_tag = "#{i + 1}"
        section_name = section[0]
        section_path = @project_path + "/#{number_tag}_#{section_name}"
        r = RLayout::YbSection.new(section_path: section_path)
        output_path = section_path + "/output.pdf"
        # r.save_pdf(output_path)
      end
    end

    def build_book

    end

    # setup listen and rake for job folder
    def self.setup_linsten_and_rake(path)

    end

    def self.listen_content
      s =<<~EOF
      require 'listen'

      listener = Listen.to('Drop/') do |added|
        puts(added: added)
        system("rake build")
      end
      listener.start
      sleep
      EOF
    end

    # TODO: do multi-threaded rake
    def self.rakefile_content
      s =<<~EOF
      require_relative 'process_pdf'
      require 'pry'
      
      desc 'build'
      task :build do
        drop_folders = Rake::FileList['Drop/2021*']
        puts "drop_folder:#{drop_folder}"
        
        drop_files.each do |pdf_file|
          RLayout::Yearbook.new(project_path: #{pdf_file})
          # move it to Done folder
        end
      end
      EOF
    end
  end
  
end