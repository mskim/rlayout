
# PagePlan is used for planing publication
# PagePlan is also used to collect the document template for articles.
# There are several speciall sections such as, toc, ad, cover, index

module RLayout
  class PagePlan
    attr_accessor :publication_type, :publication, :issue, :binding
    attr_accessor :template_path
    def initialize(path, options={}, &block)
      
      self
    end
    
    # PagePlan
    # key is the page number
    # first word is name of template
    # rest of text is the title or info
    def create_page_plan
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
