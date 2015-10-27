

module RLayout
  
  # BookAssembler assembles each documents in the page plan to a single book.
  # 
  class BookBuilder
    def build
      compile
      link
      assemble
    end
    
    # compile each document
    def compile
      
    end
    
    # compile post generated files
    def link
      
    end
    
    # assembe generated docuemnts into one book
    def assemble
      
    end
    
  end
  
  # PagePlan is used for planing publication
  # PagePlan is also used to collect the document template for articles.
  # There are several speciall sections such as, toc, ad, cover, index
  
  class PagePlan
    attr_accessor :publication_type, :publication_name, :issue, :binding
    attr_accessor :template_path
    def initialize(path, options={}, &block)
      
      
      self
    end
    
    def collect_templates
      
    end
    
    def make_pdf_book
      
    end
    
    # PagePlan
    # key is the page number
    # first word is name of template
    # rest of text is the title or info
    def create_page_plan
      SAMPLE_CSV_PLAN <<-EOF.gsub(/^\s*/, "")
      ---
      publication: MyMagazine
      issue: 2015_10
      ---
      page, template, title
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
      
      SAMPLE_PLAN <<-EOF.gsub(/^\s*/, "")
      ---
      publication:
      issue:
      1: cover1
      2: cover2
      3: toc
      5: news
      7: people Interview With Min Soo Kim
      9: review iPhone 4
      11: review MacBook Pro
      13: review Windows 10
      15: review Galaxy 5
      17: review Tesla S5
      18: review Porche 916
      19: review Porche 916
      21: review Paragon Dron
      23: cover3
      24: cover4
      ---
      EOF

      page_plan_path = issue_path + "/page_plan.yml"
      File.open(page_plan_path, 'w'){|f| f.write SAMPLE_PLAN}
    end
    

  end
  
end
