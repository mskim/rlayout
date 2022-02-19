module RLayout

  # BookMaker
  # tool for automating book processing
  # 1. Generate folder structure from book_plan.yml
  # 1. Place design layout from design template by section
  # 1. Layout each section
  # 1. Generate TOC
  # 1. Generate Index
  # 1. Combine into single PDF book
  # 1. Create static website 
  # 1. Create imposition for print.

  class BookMaker
    attr_reader :project_path

    def initialize(project_path, options={})

    end
    
  end

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
        RLayout::RChapter.new(document_path: "#{source}")  
      end
    end
    
    task :force_layout do
      chapter_files.each do |source|
        RLayout::RChapter.new(document_path: "#{source}")  
      end
    end
    
    front_files = Dir.glob("#{File.dirname(__FILE__)}/front_matter/**")
    task :layout_front do
      front_files.each do |source|
        RLayout::RChapter.new(document_path: "#{source}")  
      end
    end
    
    rear_files = Dir.glob("#{File.dirname(__FILE__)}/rear_matter/*{.md, .markdown}")
    task :layout_rear do
      rear_files.each do |source|
        RLayout::RChapter.new(document_path: "#{source}")  
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