module RLayout

  # BookMaker
  # tool for automating book processing
  # 1. create build folder
  # 1. create book_cover
  # 1. process front_matter
  # 1. Layout each body_chapter
  # 1. Generate TOC
  # 1. Generate Index
  # 1. Combine into single PDF book
  # 1. Create ebook
  # 1. 

  # 
  PAPERBACK_STYLE = {
    'chapter':{

    },
    'book_cover':{

    },
    'front_matter':{

    }
  }

  
  class Paperback
    attr_reader :project_path, :build_folder, :book_info
    attr_reader :has_inner_cover, :has_wing

    def initialize(project_path, options={})
      @project_path = project_path
      @build_folder = @project_path + "/build"
      FileUtils.mkdir_p(@build_folder) unless File.exist?(@build_folder)
    
      create_book_cover
      process_front_matter
      process_body_matter
      process_rear_matter
      generate_toc
      generate_inner_book
      generate_pdf_book # merge cover with inner_book
      generate_ebook unless options[:no_ebook]
    end
  end

  ########### book_cover ###########
  def source_book_cover_path
    @project_path + "/book_cover"
  end
 
  def build_book_cover_path
    build_folder + "/book_cover"
  end

  def create_book_cover
    RLayout::BookCover.new(project_path: build_book_cover_path)
  end

  ########### front_matter ###########
  def front_matter_path
    @project_path + "/front_matter"
  end

  def process_front_matter
    puts __method__

  end

  ########### body_matter ###########
  def process_body_matter
    puts __method__

  end

  ########### rear_matter ###########
  def rear_matter_path
    @project_path + "/rear_matter"
  end

  def process_rear_matter
    puts __method__

  end

  ########### toc ###########
  def generate_toc
    puts __method__

  end

  ########### assemble book ###########
  def generate_inner_book
    puts __method__

  end
  
  def generate_pdf_book # merge cover with inner_book
    puts __method__

  end

  def generate_ebook
    puts __method__

  end


  ###############################################
  ############### rake tasks ####################
  def rakefile_path
    @project_path + "/Rakefile"
  end

  def rakefile_content
    s =<<~EOF
    require 'rake'
    require 'rlayout'
    
    task :default => :pdf    
    chapter_files = Dir.glob("#{File.dirname(__FILE__)}/*chapter/*{.md, .markdown}")
    
    task :pdf => chapter_files.map {|source_file| source_file.sub(File.extname(source_file), ".pdf") }
    chapter_files.each do |source|
      ext = File.extname(source_file)
      pdf_file = source_file.sub(ext, ".pdf")
      file pdf_file => source_file do
        RLayout::RChapter.new(chapter_path: "#{source}")  
      end
    end
    
    task :force_layout do
      chapter_files.each do |source|
        RLayout::RChapter.new(chapter_path: "#{source}")  
      end
    end
    
    front_files = Dir.glob("#{File.dirname(__FILE__)}/front_matter/**")
    task :layout_front do
      front_files.each do |source|
        RLayout::RChapter.new(chapter_path: "#{source}")  
      end
    end
    
    rear_files = Dir.glob("#{File.dirname(__FILE__)}/rear_matter/*{.md, .markdown}")
    task :layout_rear do
      rear_files.each do |source|
        RLayout::RChapter.new(chapter_path: "#{source}")  
      end
    end
    EOF
  end

  def save_rakefile
    File.open(rakefile_path, 'w'){|f| f.write rakefile_content}
  end

  def github_action_workflow_path
    @project_path + ".git/workflows/build_pdf"
  end
  
  def git_action_content
    s =<<~EOF
    name: build_pdf
    on: [push, pull_request]
    jobs:
      build:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v2
          - uses: ruby/setup-ruby@v1
            with:
              ruby-version: 3.0 # not needed if `.ruby-version` exists
              bundler-cache: true # runs `bundle install` and caches installed gems automatically
          - run: bundle exec rake
    EOF
  end

  def save_github_action_workflow
    File.open(git_action_content, 'w'){|f| f.write git_action_content}

  end

end