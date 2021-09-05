module RLayout
  attr_reader :project_path, :name, :page_size
  attr_reader :sections, :page_count
  class NewsPublication
    def initialize(options={})
      @project_path = options[:project_path]
      @page_size = options[:page_size] || 'A3'
      @page_count = options[:page_count]
      @sections = options[:sections] || default_sections
      
      self
    end

    def config_info
      h = {}
      h[:project_path] = @project_path
      h[:page_size] = @page_size
      h[:sections] = @sections
    end

    def config_path
      @project_path + "/config.yml"
    end

    def save_config_info
      File.open(config_path, 'w'){|f| f.write config_info.to_yaml}
    end

    def default_sections
      %w[정치 경재 광고 산업 오피니언 전면광고]
    end

    def rakefile_path
      @project_path + "/Rakefile"
    end
  
    def rakefile_content
      s =<<~EOF
      require 'rake'
      require 'rlayout'
      
      task :default => :update_pages
      page_pdfs = FileList["**/section.pdf"]
      page_files = page_pdfs.map{|f| File.dirname(f)}
      # puts page_files
      story_md_files = FileList["**/*.md", "**/*.markdown"]
      story_pdf_files = story_md_files.ext(".pdf")
      task :update_pages do
        puts "update_pages"
        page_files.each do |page|
          story_md_files.each_with_index do |md, i|
            if !File.exist?(story_pdf_files[i])
              page_full_path = File.expand_path(page)
              RLayout::NewsPage.new(page_path: page_full_path, update_if_changed: true)
            elsif  File.mtime(md) > File.mtime(story_pdf_files[i])
              page_full_path = File.expand_path(page)
              RLayout::NewsPage.new(page_path: page_full_path, update_if_changed: true)
            else
              # puts "#{md} is upto date!"
            end
          end
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

end