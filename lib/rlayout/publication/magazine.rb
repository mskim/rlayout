# encoding: utf-8

# publication

# Issue
#   PagePlan
#   Sections
#   Articles
#   AdPage
# 

# workflow
#  1. create page_plan in csv file 
#       sections
#       articles
#       ads
#  2. generate dummpy pages
#  3. Fill in the dummy pages with content
#  4. Preview in on the web
#  5. Fine tune

# Templates
#    TOC
#    interview-1
#    interview-2
#    interview-3
#    interview-4

MAGAZINE_SECTIONS = %w{cover toc news interview review}

module RLayout
  
  class Magazine 
    attr_accessor :name, :publication_path, :sections, :ad, :articles
    attr_accessor :page_plan, :style_sheet
    
    def initialize(options={}, &block)
      # system("mkdir -p #{publication_path}") unless File.exists?(publication_path)
      @name         = options.fetch(:name,"OurTimes")
      @path         = options.fetch(:path, "/Users/Shared/Newspaper")
      @publication_path = "#{@path}/#{@name}"
      @paper_size   = options.fetch(:paper_size,"A2")
      @width        = SIZES[@paper_size][0]
      @height       = SIZES[@paper_size][1]
      setup
      super
      self
    end
    
    def setup
      system "mkdir -p #{@publication_path}" unless File.exist?(@publication_path)
      save_config_file
    end
    

    #TODO
    # breaks for digit that are already 3 digits or more
    # breaks for filenames with space 
    def normalize_filenames
      new_names = []
      Dir.glob("#{@folder_path}/*") do |m|
        basename = File.basename(m)
        if basename =~ /^\d+/
          r= /^\d*/
          matching_string = (basename.match r).to_s
          long_digit = make_long_ditit(matching_string, 3)
          new_base = basename.sub(matching_string, long_digit)
          new_path = @folder_path + "/#{new_base}"
          puts m
          puts new_path
          # system("mv #{m} #{new_path}")
        end
      end
      new_names
    end
  end  

  class MagazineIssue
    attr_accessor :publication_path, :issue_date, :issue_number, :issue_path
    def initialize(publication_path, options={})
      @publication_path = publication_path
      @issue_date  = options.fetch(:issue_date, "2015-4-5")
      @issue_path = @publication_path + "/" + @issue_date
      create_page_plan
      create_articles
      self
    end
    
    def create_page_plan
      
    end
    
    def create_articles
      publication_config = File.open(@publication_path + "/config.yml", 'r'){|f| f.read}
      @publication_info = YAML::load(publication_config)
      @publication_info['sections'].each_with_index do |section_name, i|
        section_path = @issue_path + "/#{section_name}"
        if i== 0
          magazine_section = MagazineSection.new(nil, :section_path=>section_path, :section_name=>section_name, :output_path=> output_path, :number_of_stories=>@publication_info['number_of_stories'][i], :has_heading=>true)
        else
          magazine_section = MagazineSection.new(nil, :section_path=>section_path,  :section_name=>section_name, :output_path=> output_path, :number_of_stories=>@publication_info['number_of_stories'][i])
        end
        news_section.create_section
        news_section.update_section
      end
    end
    
  end  
  
  # cover
  #  cover_1
  #  cover_2
  #  cover_3
  #  cover_4
  # TOC
  # news
  # interview
  # new_product
  # Listing
  
  class PagePlan
    attr_accessor :imposition_type # sattle_stiching, 
    attr_accessor :page_plan_sheet
    attr_accessor :page_runs
    
    def initialize(issue_path, options={})
      
      self
    end
  end

end
