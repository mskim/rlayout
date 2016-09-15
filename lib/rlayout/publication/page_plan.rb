

module RLayout
  
  # BookAssembler assembles each documents in the page plan to a single book.
  # PagePlan is used for planing publication
  # PagePlan is also used to collect the document template for articles.
  # There are several speciall sections such as, toc, ad, cover, index
  
  class PagePlan
    attr_accessor :publication_type, :publication_name, :issue, :binding
    attr_accessor :project_path, :template_path, 
    def initialize(project_path, options={}, &block)
      @publication_type = options.fetch(:type, "Chapter")
      create_page_plan
      self
    end
    
    def collect_templates
      
    end
    
    
    # PagePlan
    # key is the page number
    # first word is name of template
    # rest of text is the title or info
    def create_page_plan
      SAMPLE_MAGAZINE_PLAN <<-EOF.gsub(/^\s*/, "")
      ---
      publication: MyMagazine
      type: Magazine
      template: magazine_1
      issue: 2015_10
      ---
      
      1, cover1,
      2, cover2, Samsung Ad
      3, toc,
      5, news,
      7, Interview, Interview With Min Soo Kim
      9, Interview, Interview Obama
      11, techtalk, MacBook Pro
      13, techtalk, Windows 10
      15, review, Galaxy 5
      17, review, Tesla S5
      18, opinion, Porche 916
      19, opinion, Porche 916
      21, opinion, Paragon Dron
      23, cover3, LG Ad
      24, cover4, Apple Ad
      
      EOF
      
      SAMPLE_CHAPTER_PLAN <<-EOF.gsub(/^\s*/, "")
      ---
      publication: MySampleBook
      author: Some Author
      ---
      
      cover1
      cover2
      toc
      1.chapter
      2.chapter iPhone 4
      3.chapter MacBook Pro
      4.chapter Windows 10
      5.chapter Galaxy 5
      6.chapter Tesla S5
      7.chapter Porche 916
      cover3
      cover4
      
      EOF

      page_plan_path = @project_path + "/page_plan.yml"
      case @publication_type
      when "Book"
        File.open(page_plan_path, 'w'){|f| f.write SAMPLE_CHAPTER_PLAN}
      when "Magazine"
        File.open(page_plan_path, 'w'){|f| f.write SAMPLE_MAGAZINE_PLAN}
      else
        File.open(page_plan_path, 'w'){|f| f.write SAMPLE_CHAPTER_PLAN}
      end
    end
  end

  class Signature
  	attr_accessor :page_count, :template
	
  end

  class PagePlaceHolder
  	attr_accessor :page_count, :page_type
  end

end
