module RLayout

  class NewsIssuePlan
    attr_reader :publication_path, :date, :issue_path

    def initialize(options={})
      @publication_path = options[:publication_path]
      @date = options[:date]
      save_sample_issue_plan
      create_page_md_files
      self
    end

    def create_page_md_files
      issue_plan = YAML::load_file(issue_plan_path)
      issue_plan['pages'].each_with_index do |page_info, i|
        page_md_path = @publication_path + "/#{@date}_#{(i+1).to_s.rjust(2,'0')}.md"
        self.save_page_md(page_info, page_md_path)
      end
    end

    def self.page_heading
      <<~EOF

      ---

      page_number: #{@page_number}
      section_name: #{@section_name}
      ad_type: #{@ad_type}
      advertiser: #{@advertiser}

      ---

      EOF
    end

    def self.save_page_md(page_info, page_md_path)
      pillars = page_info[:pillars]
      @page_number = page_info[:page_number]
      @section_name = page_info[:section_name]
      @ad_type = page_info[:ad_type]
      @advertiser = page_info[:advertiser]
      page_md_content = self.page_heading
      if pillars.length > 0
        pillars.each do |pillar_array|
          # pillar_column = pillar_array[0]
          article_count = pillar_array[1]
          page_md_content += self.sample_pillar_article_of(article_count)
        end
      else
        # when full page ad
      end
      
      File.open(page_md_path, 'w'){|f| f.write page_md_content}
    end

    def issue_plan_path
      @publication_path + "/#{@date}_issue_plan.yml"
    end

    def save_sample_issue_plan
      File.open(issue_plan_path, 'w'){|f| f.write sample_issue_plan} unless File.exist?(issue_plan_path)
    end

    def sample_issue_plan
      <<~EOF

      ---
      date: #{@date}
      pages:
      - page_number: 1
        section_name: 1면
        pillars: [[4,2], [2,3]]
        ad_type: 5단통
        advertiser: 삼성전자
      - page_number: 2
        section_name: 소식
        pillars: [[3,3], [3,3], [3,3]]
      - page_number: 3
        section_name: 소식
        pillars: [[3,3], [3,3], [3,3]]
      - page_number: 4
        section_name: 전면광고
        ad_type: 15단통
        advertiser: LG전자

      EOF
    end

    def self.sample_pillar_article_of(count)
      content = "\npillar\n\n"
      count.times do
        content += sample_article
      end
      content += "\n\n"
      content
    end

    def self.sample_article
      <<~EOF

      # article

      ---
      title: 여기는 기사 제목 입니다.
      subtitle: 여기는 기사 부제목 입니다.
      reporter: 홍길동

      ---

      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다.
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 

      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다.
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 

      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다.
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 
      여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 

      EOF

    end

    def self.sample_article_english
      <<~EOF

      # article

      ---
      title: Article title goes here.
      subtitle: Book Subitle Here
      reporter: Gil Dong Hong

      ---

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      EOF

    end

  end
end