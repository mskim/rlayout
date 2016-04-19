# encoding: utf-8

# magazine new name --template==spring
# rake new_issue date
# rake create aticles
# rake update pdf 
# rake publish pdf_book
# rake publish web_site


# publication

# Issue
#   PagePlan
#   1.cover
#   2.cover 
#   3.toc
#   4.ad_Samsung
#   5.ad_Apple
#   6.ad_Apple
#   7.interview: Min Soo Kim
#   .
#   .
#   .

#   Guardfile

# workflow
#  1. create page_plan in yml file 
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
#    news-1
#    news-2
#    news-3
#    news-4



MAGAZINE_SECTIONS = %w{cover toc news interview review}

module RLayout
    
  class Magazine 
    attr_accessor :name, :publication_path, :sections, :ad, :articles
    attr_accessor :page_plan, :style_sheet
    
    def initialize(options={}, &block)
      # system("mkdir -p #{publication_path}") unless File.exists?(publication_path)
      @name         = options.fetch(:name,"MyMagazine")
      @path         = options.fetch(:path, "/Users/Shared/Newspaper")
      @publication_path = "#{@path}/#{@name}"
      @paper_size   = options.fetch(:paper_size,"A2")
      @width        = SIZES[@paper_size][0]
      @height       = SIZES[@paper_size][1]
      setup
      self
    end
    
    def setup
      # system "mkdir -p #{@publication_path}" unless File.exist?(@publication_path)
      # save_config_file
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
    
    # 1. search each article folder and get  .md file
    # 1. look for yaml header
    # 1. get title
    # 1. save a file called toc.md in toc article folder
    def self.create_toc(project_path)
      toc_text = ""
      Dir.glob("#{project_path}/**/*.md") do |story|
        title_text = '# '
        title_text += Story.get_metadata_from_stroy(story)["title"]
        title_text += "\t{{page_number}}"
        toc_text += title_text
        toc_text += "\r\n"
      end
      toc_folder = project_path + "/toc"
      system("mkdir -p #{toc_folder}") unless File.exist?(toc_folder)
      toc_md_path = toc_folder + "/toc.md"
      File.open(toc_md_path, 'w'){|f| f.write toc_text}
    end
    
    def create_news_issue(issue_date)
      
    end
  end  

  class MagazineIssue
    attr_accessor :publication_path, :issue_date, :issue_number, :issue_path
    def initialize(publication_path, options={})
      @publication_path = publication_path
      @issue_date  = options.fetch(:issue_date, "2015-4-5")
      @issue_path = @publication_path + "/" + @issue_date
      create_page_plan
      # create_articles
      self
    end
    
    def create_article_with_page_plan
      #copy article templates
            
    end
    
    def create_articles
      publication_config = File.open(@publication_path + "/config.yml", 'r'){|f| f.read}
      @publication_info = YAML::load(publication_config)
      @publication_info['sections'].each_with_index do |section_name, i|
        section_path = @issue_path + "/#{section_name}"
        if i== 0
          magazine_section = MagazineSection.new(:section_path=>section_path, :section_name=>section_name, :output_path=> output_path, :number_of_stories=>@publication_info['number_of_stories'][i], :has_heading=>true)
        else
          magazine_section = MagazineSection.new(:section_path=>section_path,  :section_name=>section_name, :output_path=> output_path, :number_of_stories=>@publication_info['number_of_stories'][i])
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
    attr_accessor :page_plan
    attr_accessor :page_runs
    
    def initialize(issue_path, options={})
      
      self
    end
    
    def generate_toc
      
    end
  end

end
